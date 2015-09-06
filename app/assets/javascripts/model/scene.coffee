class Moon.Model.Scene extends Backbone.Model
  initialize: (attributes, options) ->
    @layers = new Moon.Collection.Layers
    @events = new Moon.Collection.Events
    @preevents = new Moon.Collection.Events
    @dynamic_events = new Moon.Collection.Events
    @actors = new Moon.Collection.Actors


  init_layers: (layers_data) ->
    @layers.reset layers_data

  init_events: (events_data)  ->
    @events.reset events_data

  init_preevents: (preevents_data)  ->
    @preevents.reset preevents_data

  init_actors: (actors_data) ->
    @actors.reset actors_data

  init_dynamic_events: (dynamic_events_data) ->
    @dynamic_events.reset dynamic_events_data