class PiG.View.BaseView extends SUI.View
  constructor: (options) ->
    @scene = options.scene
    super options


  _adjust_scale: ->
    @$el.css fontSize: 1*@app.view.current_scale