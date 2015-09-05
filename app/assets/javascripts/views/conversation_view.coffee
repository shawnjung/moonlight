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
    'click': 'skip_animation_or_next'

  skip_animation_or_next: (e) ->
    e.stopPropagation()

    if @_typing
      @_stop_typing()
      @_show_message @current_message_index
    else
      next_index = @current_message_index+1
      if @messages.at next_index
        @_stop_typing()
        @_show_message next_index, typing: true
      else
        @hide =>
          @remove()
          @scene.view.next()




  show: ->
    @scene.view.register_receiver this
    @$el.transition y: '0', opacity: 1, 800, =>
      @_show_message 0, typing: true

  hide: (callback) ->
    @scene.view.unregister_receiver()
    @$el.transition y: '15%', opacity: 0, 800, =>
      callback() if callback instanceof Function



  _show_message: (index, options = {}) ->
    message = @messages.at index
    actor   = @scene.actors.get message.get('actor_id')

    if actor and actor_name = actor.get('short_name')
      @$name.html actor.get('short_name')
      @$el.addClass 'show-name-label'
    else
      @$el.removeClass 'show-name-label'

    @$message.css fontSize: "#{message.get('font_size')}em"
    @$message.empty()

    if options.typing
      @_type_message message.get('message'), message.get('speed')
    else
      @$message.html message.get('message')

    @current_message_index = index

  _type_message: (message_text, interval) ->
    @_stop_typing()
    return unless message_text
    @$message.append "<span class='letter'>#{message_text[0]}</span>"
    @$message_area.scrollTop @$message_area.prop('scrollHeight') - @$message_area.height()

    @_typing = setTimeout =>
      @_type_message message_text.substring(1), interval
    , interval

  _stop_typing: ->
    clearTimeout @_typing
    delete @_typing

  _render: ->
    @$el.html @template()
    @$el.css opacity: 0, y: '15%'
    @$name    = @$(".name")
    @$message = @$(".message")
    @$message_area = @$(".message-area")



  _adjust_scale: ->
    @$el.css fontSize: 1*@app.view.current_scale

  _position: (layer_id) ->
    layer = @scene.layers.get layer_id
    layer.view.$el.append @el