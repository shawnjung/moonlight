#= require namespace
#= require_tree ./model
#= require_tree ./collection
#= require_tree ./helpers
#= require_tree ./plugins
#= require_tree ./views
#= require_self

class PiG.SceneManager extends SUI.Router
  screen_ratio:
    width: 2
    height: 3

  screen_size:
    width: 640
    height: 960

  initialize: (options = {}) ->
    @view   = new PiG.View.ApplicationView app: this
    @game   = new PiG.Model.Game

    $.ajax
      url: options.json
      success: (response) =>
        @game.init_game_data_from response
        @game.preload_assets =>
          Backbone.history.start()

  routes:
    '': 'move_to_first_scene'
    'scenes/:scene_id': 'show_scene_view'


  move_to_first_scene: ->
    @navigate "scenes/#{@game.scenes.first().id}", trigger: true


  show_scene_view: (id) ->
    scene = @game.scenes.get id
    view  = scene.load_view_class()
    @render_scene view, model: scene



  render_scene: (view_class, options = {})->
    options = _({app: this}).extend options
    render_scene = =>
      @_current_scene.remove() if @_current_scene
      @_current_scene = new view_class options

    if @_current_scene instanceof PiG.View.SceneView
      @_current_scene.perform_post_events render_scene
    else
      render_scene()


