class PiG.View.ApplicationView extends SUI.View
  id: 'application-view'
  template: TPL('application')
  current_scale: 1

  initialize: (options) ->
    @screen_ratio = @app.screen_ratio
    @screen_size  = @app.screen_size

    @_render()
    @_position()
    @_adjust_size()

    $(window).resize => @_adjust_size()

  render_scene: (scene_view) ->
    @$scene_area.append scene_view.el


  _render: ->
    @$el.html @template()
    @$scene_area = @$(".scene-area")

  _position: ->
    $('body').append @el


  _adjust_size: ->
    current_ratio = @screen_ratio.width/@screen_ratio.height
    window_width  = $(window).width()
    window_height = $(window).height()
    screen_width  = $(window).height() * current_ratio
    screen_height = window_height

    if screen_width > window_width
      screen_width = window_width
      screen_height = screen_width/current_ratio

    @$el.css
      width: screen_width, height: screen_height
      marginLeft: screen_width*-0.5, marginTop: screen_height*-0.5

    @current_scale = screen_width/@screen_size.width
    @app.trigger 'scale-changed', @current_scale