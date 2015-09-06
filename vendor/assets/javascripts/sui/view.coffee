class SUI.View extends Backbone.View
  constructor: (options) ->
    @app    = options.app
    @parent = options.parent
    super options