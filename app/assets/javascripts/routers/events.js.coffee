class CPP.Routers.Events extends Backbone.Router
  routes:
      'companies/:company_id/events'      : 'index'
      'companies/:company_id/events/new'  : 'new'
      'events/:id/edit'                   : 'edit'
      'events/:id'                        : 'view'

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

  view: (id) ->
    event = new CPP.Models.Event id: id
    event.fetch
      success: ->
        event.company = new CPP.Models.Company id: event.get("company_id")
        event.company.fetch
          success: ->
            new CPP.Views.EventsView model: event
          error: ->
            notify "error", "Couldn't fetch company for event"
      error: ->
        notify "error", "Couldn't fetch event"
