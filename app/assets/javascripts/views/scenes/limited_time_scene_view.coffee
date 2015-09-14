class PiG.View.LimitedTimeSceneView extends PiG.View.SceneView
  className: 'limited-time-scene scene-view'
  limited_time: 0
  initialize: (options) ->
    @_init_associations options
    @_init_time()
    @_render()
    @_render_layer_views()
    @_render_time_indicator()
    @_position()

    @_start_from @current_event_index
    @_countdown_limited_time_as_reatime() if @model.get('options').realtime


  spend_time: (options) ->
    @limited_time.subtract options.time


  _init_time: ->
    @limited_time = new PiG.Model.LimitedTimeScene.Time
      time: @model.get('options').time

  _render_time_indicator: ->
    layer_view = @layer_manager.get @model.get('options').indicator_layer
    new PiG.View.TimeIndicatorView
      app: @app, parent: this, scene: @model,
      layer_view: layer_view, model: @limited_time



  _countdown_limited_time_as_reatime: ->
    @_countdown = setInterval =>
      @limited_time.subtract 1
      clearInterval @_countdown if @limited_time.get('seconds') <= 0
    , 1000

