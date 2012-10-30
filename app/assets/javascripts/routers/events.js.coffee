class CPP.Routers.Events extends Backbone.Router
  routes:
      'companies/:company_id/events'      : 'index'
      'companies/:company_id/events/new'  : 'new'
      'events/:id/edit'                   : 'edit'

  index: (company_id) ->
    events = new CPP.Collections.Events
    new CPP.Views.EventsIndex collection: events
    events.fetch({ data: $.param({ company_id: company_id}) })

  new: (company_id) ->
    event = new CPP.Models.Event company_id: company_id
    event.collection = new CPP.Collections.Events
    new CPP.Views.EventsEdit model: event

  edit: (id) ->
    event = new CPP.Models.Event id: id
    event.fetch
      success: ->
        new CPP.Views.EventsEdit model: event
      error: ->
        notify "error", "Counld't fetch event"
