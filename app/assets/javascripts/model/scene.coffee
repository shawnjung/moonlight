class PiG.Model.Scene extends Backbone.Model
  view_namespace: 'PiG.View'
  initialize: (attributes, options) ->
    @actors = new PiG.Collection.Actors
    @layers = new PiG.Collection.Layers
    @events = new PiG.Collection.Events
    @pre_scene_events = new PiG.Collection.Events
    @post_scene_events = new PiG.Collection.Events
    @dynamic_events = new PiG.Collection.Events


  init_actors: (actors_data) ->
    @actors.reset actors_data

  init_layers: (layers_data) ->
    @layers.reset layers_data

  init_events: (events_data)  ->
    @events.reset events_data

  init_pre_scene_events: (pre_scene_events_data)  ->
    @pre_scene_events.reset pre_scene_events_data

  init_post_scene_events: (post_scene_events_data)  ->
    @post_scene_events.reset post_scene_events_data

  init_dynamic_events: (dynamic_events_data) ->
    @dynamic_events.reset dynamic_events_data

  load_view_class: ->
    namespace = eval @view_namespace
    output = namespace[@get('view')]
    output = namespace.SceneView unless output
    output