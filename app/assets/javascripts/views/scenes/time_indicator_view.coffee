class PiG.View.TimeIndicatorView extends PiG.View.BaseView
  className: 'time-indicator-view'
  template: TPL('scenes/time_indicator')
  default_options:
    format: '[mm][:][ss]'
    font_size: 36

  initialize: (options) ->
    @layer_view = options.layer_view
    @options    = _(@scene.get('options')).pick 'format', 'font_size'

    _(@options).defaults @default_options

    @_render()
    @_position()
    @_adjust_scale()
    @listenTo @model, 'change:seconds', @_render

  _render: ->
    @$el.html @template()
    @$(".time-strings").
      css('font-size', @options.font_size + 'em').
      html @_parse_time_format @model.humanize()

    @$(".time-separator").addClass 'blinking' if @scene.get('options').realtime

  _position: ->
    @layer_view.$el.append @el

  _parse_time_format: (data) ->
    @options.format.
      replace('[:]', "<span class='time-separator'>:</span>").
      replace('[hh]', @_time_string_tpl('hours', data.hours, true)).
      replace('[mm]', @_time_string_tpl('minutes', data.minutes, true)).
      replace('[ss]', @_time_string_tpl('seconds', data.seconds, true)).
      replace('[h]', @_time_string_tpl('hours', data.hours, false)).
      replace('[m]', @_time_string_tpl('minutes', data.minutes, false)).
      replace('[s]', @_time_string_tpl('seconds', data.seconds, false))

  _time_string_tpl: (type, value, zero_padding) ->
    value = ("0"+value).substr(-2) if zero_padding
    "<span class='#{type} time-string'>#{value}</span>"


