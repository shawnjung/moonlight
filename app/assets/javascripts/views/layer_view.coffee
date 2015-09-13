class PiG.View.LayerView extends PiG.View.BaseView
  className: 'layer-view'
  initialize: (options) ->
    @scene = options.scene

    @model.view = this
    @$el.prop 'id', "layer-#{@model.id}"
    @$el.css 'z-index', @model.get('z')
    @scene.view.$el.append @el