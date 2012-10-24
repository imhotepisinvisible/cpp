class CPP.Routers.Events extends Backbone.Router
  routes:
      'events': 'index'
      'events/new' : 'new'

  index: ->
    events = new CPP.Collections.Events
    new CPP.Views.EventsIndex collection: events
    events.fetch()

  new: ->
    event = new CPP.Models.Event
    event.collection = new CPP.Collections.Events
    new CPP.Views.EventsNew model: event 