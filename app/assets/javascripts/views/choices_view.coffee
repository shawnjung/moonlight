class PiG.View.ChoicesView extends PiG.View.BaseView
  className: 'choices-view'
  template: (type, attrs) ->
    @_template  = switch type
                    when 'pointer' then TPL('choices_pointer')
                    else TPL('choices_text')

    @_template attrs

  item_view_classes:
    text: 'PiG.View.TextChoiceView'
    pointer: 'PiG.View.PointerChoiceView'

  default_render_options:
    title: ''
    description: ''

  default_visual_options:
    background_asset_id: null
    background_color: '000000'
    background_opacity: 0.7

  default_choice_options:
    type: 'text'
    font_size: 46
    radius: 50


  initialize: (options) ->
    @render_options = _(options).pick 'title', 'description'
    @visual_options = _(options).pick 'background_asset_id', 'background_color', 'background_opacity'
    @choice_options =
      type:      options.choice_type
      font_size: options.choice_font_size
      radius:    options.choice_radius

    _(@render_options).defaults @default_render_options
    _(@visual_options).defaults @default_visual_options
    _(@choice_options).defaults @default_choice_options



    @choices = new PiG.Collection.Choices options.choices

    @_render()
    @_render_background()
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
    scroll_width  = @$background_wrap.prop 'scrollWidth'
    scroll_height = @$background_wrap.prop 'scrollHeight'

    @$background_wrap.scrollLeft (scroll_width-@app.view.$el.width())/2
    @$background_wrap.scrollTop (scroll_height-@app.view.$el.height())/2
    @scene.view.register_receiver this
    @$el.transition y: '0', opacity: 1, 800, =>
    @_show_choice_items()

  hide: (callback) ->
    @scene.view.unregister_receiver()
    @$el.transition y: '2%', opacity: 0, 800, =>
      callback() if callback instanceof Function


  _render: ->
    @$el.html @template @choice_options.type, @render_options
    @$el.addClass "#{@choice_options.type}-type"
    @$choice_list = @$(".choice-list")
    @$background_wrap = @$(".background-wrap")

    @$el.css opacity: 0, y: '2%'

  _render_background: ->
    bg_color = _(@visual_options.background_color).toRGB()
    @$el.css 'background-color', "rgba(#{bg_color.r},#{bg_color.g},#{bg_color.b},#{@visual_options.background_opacity})"

    return unless @visual_options.background_asset_id

    background_asset = @app.game.assets.get @visual_options.background_asset_id

    background_view = new PiG.View.ImageView
      app: @app, parent: this, asset: background_asset
      wrapper_el: @$background_wrap[0]

    @$choice_list.css
      width:  background_view.el.style.width
      height: background_view.el.style.height


  _render_choices: ->
    @_choice_items = []
    @choices.each (choice) =>
      item_options    = app: @app, parent: this, scene: @scene, model: choice
      item_view_class = eval(@item_view_classes[@choice_options.type])

      choice_view = new item_view_class _(item_options).defaults @choice_options
      @_choice_items.push choice_view

  _show_choice_items: ->
    _(@_choice_items).each (view, index) ->
      setTimeout =>
        view.show()
      , 300*index


  _position: (layer_id) ->
    layer = @scene.layers.get layer_id
    layer.view.$el.append @el

