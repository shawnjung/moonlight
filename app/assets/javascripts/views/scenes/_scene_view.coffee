class PiG.View.SceneView extends SUI.View
  className: 'scene-view'
  initialize: (options) ->
    @_init_associations options
    @_render()
    @_render_layer_views()
    @_position()

    @_start_from @current_event_index

  _init_associations: (options) ->
    @model.view = this
    @dynamic_event_queue = []
    @current_event_index = options.current_event_index or 0
    @layer_manager       = new PiG.Helper.ViewManager
    @view_manager        = new PiG.Helper.ViewManager
    @audio_manager       = new PiG.Helper.ViewManager

  events:
    'click': 'next'

  next: (e) ->
    return @_receiver.$el.trigger e.type, e if e and @_receiver
    return @_perform_next_dynamic_event() if @dynamic_event_queue.length

    @perform_next_event()

  perform_next_event: ->
    next_index = @current_event_index+1
    event      = @model.events.at next_index

    return unless event
    @perform_event event
    @current_event_index = next_index


  perform_event: (event) ->
    if event.get('layer')
      target = @layer_manager.get event.get('layer')
    else if event.get('view')
      target = @view_manager.get event.get('view')
    else
      target = this

    return unless target
    console.log event.toJSON()
    target[event.get('method')] event.get('options')

    if event.get('auto_next')
      next_event_callback = _(@next).bind(this)
      _(next_event_callback).delay event.get('auto_next')


  perform_post_events: (callback) ->
    max_wait_time = 0
    @_receiver = undefined
    @model.post_scene_events.each (event) =>
      @perform_event event
      max_wait_time = event.get('wait') if event.get('wait') > max_wait_time

    setTimeout callback, max_wait_time + 100





  perform_dynamic_events: (dynamic_event_names) ->
    @dynamic_event_queue = dynamic_event_names.concat @dynamic_event_queue
    @_perform_next_dynamic_event()


  _perform_next_dynamic_event: ->
    event_name = @dynamic_event_queue.shift()
    switch
      when event_name is 'next'
        @perform_next_event()
      when event_name is 'back'
        event = @model.events.at @current_event_index
        @perform_event event
      when event_name instanceof Object
        @perform_event new @model.events.model event_name
      else
        dynamic_event = @model.dynamic_events.get event_name
        @perform_event dynamic_event


  fade: (options) ->
    prepare_options = {}
    animate_options = {}
    if _(options.opacity).isArray()
      prepare_options.opacity = options.opacity[0]
      animate_options.opacity = options.opacity[1]
    else
      animate_options.opacity = options.opacity
    @$el.css prepare_options
    @$el.animate animate_options, options.duration


  register_receiver: (receiver_view) ->
    @_receiver = receiver_view

  unregister_receiver: ->
    @_receiver = undefined


  new_image: (options = {}) ->
    view  = new PiG.View.ImageView _(options).defaults
              app: @app, scene: @model
              asset: @app.game.assets.get(options.asset_id)

    @view_manager.add options.view_id, view
    view


  new_conversation: (options = {}) ->
    view  = new PiG.View.ConversationView _(options).defaults
              app: @app, scene: @model

    @view_manager.add options.view_id, view
    view

  new_monologue: (options = {}) ->
    view  = new PiG.View.MonologueView _(options).defaults
              app: @app, scene: @model

    @view_manager.add options.view_id, view
    view

  new_choices: (options) ->
    view  = new PiG.View.ChoicesView _(options).defaults
              app: @app, scene: @model

    @view_manager.add options.view_id, view
    view

  switch_background: (options) ->
    options.duration = options.duration/2
    @fade_out_image options, =>
      options.layer_id = 'background'
      @fade_in_image options




  play_audio: (options = {}) ->
    _(options).defaults
      loop: false
      restart: true
    asset = @app.game.assets.get(options.asset_id)

    audio = asset.audio
    audio.volume(1)
    audio.loop() if options.loop
    audio.play() if not audio.playing() or audio.playing() and options.restart

    @audio_manager.add options.audio_id, audio


  stop_audio: (options) ->
    audio = @audio_manager.get options.audio_id

    if options.fade > 0
      audio.fade 1, 0, options.fade, => audio.stop()
    else
      audio.stop()


  change_scene: (options) ->
    next_scene = @app.game.scenes.get options.scene_id
    @app.navigate "scenes/#{next_scene.id}", trigger: true


  fade_in_image: (options, callback) ->
    options.opacity = 0
    view = @new_image options
    options.opacity = 1
    view.animate options, options.duration, =>
      callback() if callback instanceof Function

  fade_out_image: (options, callback) ->
    view = @view_manager.get options.view_id, view
    options.opacity = [1,0]
    view.animate options, =>
      view.remove()
      @view_manager.remove options.view_id
      callback() if callback instanceof Function



  _render: ->
    @$el.css @model.get('options')

  _render_layer_views: ->
    @model.layers.each (layer) =>
      layer.view = new PiG.View.LayerView
        app: @app, parent: this, model: layer, scene: @model

      @layer_manager.add layer.id, layer.view


  _position: ->
    @app.view.render_scene this


  _start_from: (event_index) ->
    @model.pre_scene_events.each (event) => @perform_event event
    _(@model.events.first(event_index+1)).each (event, index) =>
      @perform_event event
      @current_event_index = index
