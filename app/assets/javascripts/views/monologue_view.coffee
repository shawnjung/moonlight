class Moon.View.MonologueView extends Moon.View.BaseView
  className: 'monologue-view'
  template: TPL('monologue')
  default_voptions:
    opacity: 0.5
    duration: 800
    speed: 10
    font_size: 28
    font_color: 'ffffff'
    background_color: '000000',
    halign: 'left',
    valign: 'top'

  initialize: (options) ->
    @current_message_index = 0
    @scene     = options.scene
    @voptions = _(options).pick 'opacity', 'duration', 'speed', 'font_size',
                                'font_color', 'background_color',
                                'halign', 'valign'
    @voptions = _(@voptions).defaults @default_voptions

    @_render()
    @_adjust_scale()
    @_position options.layer_id or 'subtitles'

    @listenTo @app, 'scale-changed', @_adjust_scale

    @messages = options.messages
    @show()


  events:
    'click': 'skip_animation_or_next'

  skip_animation_or_next: (e) ->
    e.stopPropagation()

    if @_typing
      @_stop_typing()
      @_show_message @current_message_index
    else
      next_index = @current_message_index+1
      if @messages[next_index]
        @_stop_typing()
        @_show_message next_index, typing: true
      else
        @hide =>
          @remove()
          @scene.view.next()


  show: ->
    @scene.view.register_receiver this
    @$el.transition opacity: 1, @voptions.duration, =>
      @_show_message 0, typing: true

  hide: (callback) ->
    @scene.view.unregister_receiver()
    @$el.transition opacity: 0, @voptions.duration, =>
      callback() if callback instanceof Function


  _show_message: (index, options = {}) ->
    message = @messages[index]

    @$message.css fontSize: "#{@voptions.font_size}em"
    @$message.empty()

    if options.typing
      @_type_message message, @voptions.speed
    else
      @$message.html message

    @current_message_index = index


  _type_message: (message, interval) ->
    @_stop_typing()
    return unless message
    @$message.append "<span class='letter'>#{message[0]}</span>"
    @$message_area.scrollTop @$message_area.prop('scrollHeight') - @$message_area.height()

    @_typing = setTimeout =>
      @_type_message message.substring(1), interval
    , interval


  _stop_typing: ->
    clearTimeout @_typing
    delete @_typing


  _render: ->
    @$el.html @template()
    @$el.css opacity: 0
    @$message = @$(".message")
    @$message_area = @$(".message-area")
    txt_color = _(@voptions.font_color).toRGB()
    bg_color  = _(@voptions.background_color).toRGB()
    @$el.css 'color', "rgb(#{txt_color.r}, #{txt_color.g}, #{txt_color.b})"
    @$el.css 'background-color', "rgba(#{bg_color.r}, #{bg_color.g}, #{bg_color.b}, #{@voptions.opacity})"
    @$el.addClass "align-#{@voptions.halign}"
    @$el.addClass "valign-#{@voptions.valign}"

  _adjust_scale: ->
    @$el.css fontSize: 1*@app.view.current_scale


  _position: (layer_id) ->
    layer = @scene.layers.get layer_id
    layer.view.$el.append @el