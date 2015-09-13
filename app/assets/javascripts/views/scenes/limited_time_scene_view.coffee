class PiG.View.LimitedTimeScene extends PiG.View.SceneView
  className: 'limited-time-scene scene-view'
  initialize: (options) ->
    @_init_associations options
    @_render()
    @_render_layer_views()
    @_position()

    @_start_from @current_event_index


