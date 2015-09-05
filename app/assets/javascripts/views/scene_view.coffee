class Moon.View.SceneView extends SUI.View
  className: 'scene-view'
  initialize: (options) ->
    @model.view = this
    @current_event_index = options.current_event_index or 0
    @image_view_manager  = new Moon.Helper.ImageViewManager

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


  render_image: (event, options = {}) ->
    image_options = event.pick 'scale', 'origin', 'position', 'opacity', 'layer_id'
    _(image_options).extend options

    view  = new Moon.View.ImageView _(image_options).defaults
              app: @app, scene: @model
              asset: @model.assets.get(event.get('asset_id'))

    @image_view_manager.add event.get('view_id'), view

  animate_image: (event, options = {}) ->
    image_options = event.pick 'scale', 'origin', 'position', 'opacity', 'duration'
    _(image_options).extend options

    view = @image_view_manager.get event.get('view_id')
    view.animate image_options

  remove_image: (event) ->
    view = @image_view_manager.remove event.get('view_id')
    view.remove()

  fade_in_image: (event) ->
    @render_image event, opacity: 0
    @animate_image event, opacity: 1



  _render_layer_views: ->
    @model.layers.each (layer) =>
      layer.view = new Moon.View.LayerView
        app: @app, parent: this, model: layer, scene: @model


  _position: ->
    @app.view.render_scene this


  _start_from: (event_index) ->
    _(@model.events.first(event_index+1)).each (event, index) =>
      @_perform_event event
      @current_event_index = index

  _perform_event: (event) ->
    @[event.get('method')] event