class PiG.View.PointerChoiceView extends PiG.View.BaseView
  tagName: 'li'
  className: 'choice-item'
  initialize: (options) ->
    @current_event_index = 0

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
    @$el.append "<div class='dot'></div>"
    @$el.css
      left: "#{@model.get('position').x*100}%"
      top: "#{@model.get('position').y*100}%"

  _position: ->
    @parent.$choice_list.append @el

