class Moon.Model.Game extends SUI.Model
  initialize: ->
    @scenes = new Moon.Collection.Scenes
    @assets = new Moon.Collection.Assets


  init_assets: (assets_data) ->
    @assets.reset assets_data

  init_scenes: (scenes_data) ->
    @scenes.reset scenes_data

  init_game_data_from: (response) ->
    @init_assets response.assets

    _(response.scenes).each (scene_data) =>
      scene = new @scenes.model scene_data
      scene.init_actors scene_data.actors
      scene.init_layers scene_data.layers
      scene.init_pre_scene_events scene_data.pre_scene_events or scene_data.preevents
      scene.init_post_scene_events scene_data.post_scene_events
      scene.init_events scene_data.events
      scene.init_dynamic_events scene_data.dynamic_events

      @scenes.add scene

  preload_assets: (callback) ->
    @loaded_assets = 0
    finish_callback = =>
      callback() if @loaded_assets is @assets.length

    @assets.each (asset) =>
      @["_preload_#{asset.get('type')}"] asset, finish_callback


  _preload_image: (asset, finish_callback) ->
    image = new Image
    image.onload = =>
      @loaded_assets++
      asset.set 'width', image.width
      asset.set 'height', image.height
      finish_callback()
    image.src = asset.get('src')


  _preload_audio: (asset, finish_callback) ->
    audio = new Howl
      urls: [asset.get('src')]
      buffer: asset.get('buffer') or false
      onload: =>
        asset.audio = audio
        @loaded_assets++
        finish_callback()
