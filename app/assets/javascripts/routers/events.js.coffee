class CPP.Routers.Events extends Backbone.Router
  routes:
      '': 'index'

  index: ->
    events = new CPP.Collections.Events
    new CPP.Views.EventsIndex collection: events
    events.fetch()
