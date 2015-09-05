class Moon.Helper.ViewManager
  constructor: (options) ->
    @views = {}


  add: (id, view) -> @views[id] = view
  get: (id) -> @views[id]
  remove: (id) ->
    output = @get(id)
    delete @views[id]
    output
