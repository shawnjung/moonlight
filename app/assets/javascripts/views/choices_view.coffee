class Moon.View.ChoicesView extends Moon.View.BaseView
  className: 'choices-view'
  template: TPL('choices')
  default_render_options:
    title: ''
    description: ''

  default_visual_options:
    choice_font_size: 46
    choice_radius: 50
    background_color: '000000'
    background_opacity: 0.7


  initialize: (options) ->
    @render_options = _(options).pick 'title', 'description'
    @visual_options = _(options).pick 'choice_font_size', 'background_color', 'background_opacity'
    _(@render_options).defaults @default_render_options
    _(@visual_options).defaults @default_visual_options

    @choices = new Moon.Collection.Choices options.choices

    @_render()
    @_render_choices()
    @_adjust_scale()
    @_position options.layer_id or 'subtitles'

    @listenTo @app, 'scale-changed', @_adjust_scale
    @show()


  events:
    'click': 'prevent_click'

  prevent_click: (e) ->
    e.stopPropagation()


  show: ->
    @scene.view.register_receiver this
    @$el.transition y: '0', opacity: 1, 800, =>
    @_show_choice_items()

  hide: (callback) ->
    @scene.view.unregister_receiver()
    @$el.transition y: '2%', opacity: 0, 800, =>
      callback() if callback instanceof Function


  _render: ->
    @$el.html @template @render_options
    @$choice_list = @$(".choice-list")
    bg_color = _(@visual_options.background_color).toRGB()
    @$el.css opacity: 0, y: '2%'
    @$el.css 'background-color', "rgba(#{bg_color.r},#{bg_color.g},#{bg_color.b},#{@visual_options.background_opacity})"

  _render_choices: ->
    @_choice_items = []
    @choices.each (choice) =>
      choice_view = new Moon.View.ChoiceView
        app: @app, parent: this, scene: @scene, model: choice
        font_size: @visual_options.choice_font_size, radius: @visual_options.choice_radius
      @_choice_items.push choice_view

  _show_choice_items: ->
    _(@_choice_items).each (view, index) ->
      setTimeout =>
        view.show()
      , 300*index


  _position: (layer_id) ->
    layer = @scene.layers.get layer_id
    layer.view.$el.append @el

