class CPP.Routers.Events extends Backbone.Router
  routes:
      'events': 'index'
      'companies/:company_id/events/new' : 'new'
      'events/:id/edit' : 'edit'

  index: ->
    events = new CPP.Collections.Events
    new CPP.Views.EventsIndex collection: events
    events.fetch()

  new: (id) ->
    event = new CPP.Models.Event company_id: id
    event.collection = new CPP.Collections.Events
    new CPP.Views.EventsEdit model: event

  edit: (id) ->
    event = new CPP.Models.Event id: id
    event.fetch
      success: ->
        new CPP.Views.EventsEdit model: event
      error: ->
        notify "error", "Counld't fetch event"
