class Moon.Collection.Scenes extends Backbone.Collection
  model: Moon.Model.Scene

  init_scenes_from: (response) ->
    _(response).each (scene_data) =>
      scene = new @model scene_data
      scene.init_assets scene_data.assets
      scene.init_layers scene_data.layers
      scene.init_events scene_data.events
      @add scene