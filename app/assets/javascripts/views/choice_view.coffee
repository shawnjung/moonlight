class Moon.View.ChoiceView extends Moon.View.BaseView
  tagName: 'li'
  className: 'choice-item'
  initialize: (options) ->
    @current_event_index = 0
    @font_size = options.font_size
    @radius    = options.radius

    @_render()
    @_position()


  events:
    'click': 'run_events'


  run_events: ->
    @parent.hide =>
      @scene.view.perform_dynamic_events @model.get('dynamic_events')
      @parent.remove()

  show: ->
    @$el.transition opacity: 1, 1000

  _render: ->
    @$text = $("<span class='text'>#{@model.get('text')}</span>")
    @$el.html @$text
    @$el.css 'border-radius': "#{@radius}em", opacity: 0
    @$text.css 'font-size', "#{@font_size}em"


  _position: ->
    @parent.$choice_list.append @el

