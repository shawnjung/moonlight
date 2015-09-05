#= require namespace
#= require_tree ./model
#= require_tree ./collection
#= require_tree ./helpers
#= require_tree ./plugins
#= require_tree ./views
#= require_self

class Moon.SceneManager extends SUI.Router
  screen_ratio:
    width: 2
    height: 3

  screen_size:
    width: 640
    height: 960

  initialize: ->
    @scenes = new Moon.Collection.Scenes []
    @view   = new Moon.View.ApplicationView app: this

    $.ajax
      url: 'the-moonlight.json'
      success: (response) =>
        @scenes.init_scenes_from response
        Backbone.history.start()

  routes:
    '': 'move_to_first_scene'
    'scenes/:scene_id': 'show_scene_view'


  move_to_first_scene: ->
    @navigate "scenes/#{@scenes.first().id}", trigger: true


  show_scene_view: (id) ->
    scene = @scenes.get id
    scene.preload_assets =>
      @render_view Moon.View.SceneView, model: scene


