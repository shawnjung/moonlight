class Moon.Model.Scene extends Backbone.Model
  idAttribute: 'scene_id'
  initialize: (attributes, options) ->
    @assets = new Moon.Collection.Assets
    @layers = new Moon.Collection.Layers
    @events = new Moon.Collection.Events


  init_assets: (assets_data) ->
    @assets.reset assets_data


  init_layers: (layers_data) ->
    @layers.reset layers_data


  init_events: (events_data)  ->
    @events.reset events_data


  preload_assets: (callback) ->
    loaded_assets = 0
    finish_callback = =>
      callback() if loaded_assets is @assets.length

    @assets.each (asset) =>
      image = new Image
      image.onload = ->
        loaded_assets++
        asset.set 'width', image.width
        asset.set 'height', image.height
        finish_callback()
      image.src = asset.get('src')