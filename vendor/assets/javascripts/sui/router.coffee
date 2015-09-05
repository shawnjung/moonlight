class SUI.Router extends Backbone.Router

  render_view: (view_class, options = {})->
    options = _({app: this}).extend options
    @_current_view = new view_class options
