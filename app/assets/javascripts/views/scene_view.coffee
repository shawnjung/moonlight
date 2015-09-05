class Moon.View.SceneView extends SUI.View
  className: 'scene-view'
  initialize: (options) ->
    @model.view = this
    @current_event_index = options.current_event_index or 0
    @view_manager        = new Moon.Helper.ViewManager

    @_render()
    @_render_layer_views()
    @_position()

    @_start_from @current_event_index




  events:
    'click': 'next_event'

  next_event: ->
    next_index = @current_event_index+1
    event      = @model.events.at next_index

    @_perform_event event
    @current_event_index = next_index


  fade: (options) ->
    prepare_options = {}
    animate_options = {}
    if _(options.opacity).isArray()
      prepare_options.opacity = options.opacity[0]
      animate_options.opacity = options.opacity[1]
    else
      animate_options.opacity = options.opacity
    @$el.css prepare_options
    @$el.animate animate_options


  new_image: (options = {}) ->
    view  = new Moon.View.ImageView _(options).defaults
              app: @app, scene: @model
              asset: @model.assets.get(options.asset_id)

    @view_manager.add options.view_id, view
    view


  new_conversation: (options = {}) ->
    view = new Moon.View.ConversationView _(options).defaults
              app: @app, scene: @model

    @view_manager.add options.view_id, view
    view


  fade_in_image: (options) ->
    options.opacity = 0
    view = @new_image options
    options.opacity = 1
    view.animate options


  _render: ->
    @$el.css @model.get('options')

  _render_layer_views: ->
    @model.layers.each (layer) =>
      layer.view = new Moon.View.LayerView
        app: @app, parent: this, model: layer, scene: @model


  _position: ->
    @app.view.render_scene this


  _start_from: (event_index) ->
    @model.preevents.each (event) => @_perform_event event
    _(@model.events.first(event_index+1)).each (event, index) =>
      @_perform_event event
      @current_event_index = index

  _perform_event: (event) ->
    if event.get('view') is 'self'
      target = this
    else
      target = @view_manager.get event.get('view')

    return unless target

    target[event.get('method')] event.get('options')

    if event.get('auto_next')
      next_event_callback = _(@next_event).bind(this)
      _(next_event_callback).delay event.get('auto_next')
