class Moon.View.ConversationView extends SUI.View
  className: 'conversation-view'
  template: TPL('conversation')
  initialize: (options) ->
    @current_message_index = 0
    @scene = options.scene
    @_render()
    @_adjust_scale()
    @_position options.layer_id or 'subtitles'

    @listenTo @app, 'scale-changed', @_adjust_scale

    @messages = new Moon.Collection.Messages options.messages
    @show()

  events:
    'click': 'next'

  next: (e) ->
    e.stopPropagation()
    clearTimeout @_typing
    @_show_message @current_message_index+1

  show: ->
    @$el.transition y: '0', opacity: 1, 800, =>
      @_show_message 0


  _show_message: (index) ->
    message = @messages.at index
    actor   = @scene.actors.get message.get('actor_id')

    if actor and actor_name = actor.get('short_name')
      @$name.html actor.get('short_name')
      @$el.addClass 'show-name-label'
    else
      @$el.removeClass 'show-name-label'


    @$message.css fontSize: "#{message.get('font_size')}em"
    @$message.empty()
    @_type_message message.get('message'), 0, message.get('speed')

    @current_message_index = index

  _type_message: (message_text, index, interval) ->
    return unless message_text
    @$message.append "<span class='letter'>#{message_text.substr(index, 1)}</span>"

    @_typing = setTimeout =>
      @_type_message message_text, index+1, interval
    , interval

  _render: ->
    @$el.html @template()
    @$el.css opacity: 0, y: '15%'
    @$name    = @$(".name")
    @$message = @$(".message")



  _adjust_scale: ->
    @$el.css fontSize: 1*@app.view.current_scale

  _position: (layer_id) ->
    layer = @scene.layers.get layer_id
    layer.view.$el.append @el