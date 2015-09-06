class Moon.Model.Scene extends Backbone.Model
  initialize: (attributes, options) ->
    @actors = new Moon.Collection.Actors
    @layers = new Moon.Collection.Layers
    @events = new Moon.Collection.Events
    @pre_scene_events = new Moon.Collection.Events
    @post_scene_events = new Moon.Collection.Events
    @dynamic_events = new Moon.Collection.Events


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