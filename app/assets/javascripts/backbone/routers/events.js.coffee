class CPP.Routers.Events extends Backbone.Router
  routes:
      'events'                               : 'index'
      'companies/:company_id/events'         : 'indexCompany'
      'companies/:company_id/events/new'     : 'new'
      'events/:id/edit'                      : 'edit'
      'events/new'                           : 'newAdmin'
      'events/:id'                           : 'view'

  indexCompany: (company_id) ->
    events = new CPP.Collections.Events
    # new CPP.Views.Events.Index collection: events
    events.fetch
      data:
        $.param({ company_id: company_id})
      success: ->
        events.company = new CPP.Models.Company id: company_id
        events.company.fetch
          success: ->
            new CPP.Views.Events.Index collection: events
          error: ->
            notify "error", "Couldn't fetch company for event"
      error: ->
        notify "error", "Couldn't fetch events"

  index: ->
    events = new CPP.Collections.Events
    events.fetch
      success: ->
        new CPP.Views.Events.Index collection: events
      error: ->
        notify "error", "Couldn't fetch events"

  new: (company_id) ->
    event = new CPP.Models.Event company_id: company_id
    event.collection = new CPP.Collections.Events
    event.company = new CPP.Models.Company id: company_id
    event.company.fetch
      success: ->
        event.company.departments = new CPP.Collections.Departments
        event.company.departments.fetch
          data:
            $.param({ company_id: event.company.id})
          success: ->
            new CPP.Views.Events.Edit model: event
      error: ->
        notify "error", "Couldn't fetch company for event"

  newAdmin: (department_id) ->
    event = new CPP.Models.Event
    event.collection = new CPP.Collections.Events
    department = new CPP.Models.Department id: window.getAdminDepartment()
    department.fetch
      success: ->
        department.companies = new CPP.Collections.Companies
        department.companies.fetch
          data:
            $.param({ department_id: window.getAdminDepartment() })
          success: =>
            new CPP.Views.Events.Edit model: event, department: department
          error: ->
            notify "error", "Couldn't fetch department companies"
      error: ->
        notify "error", "Couldn't fetch department"

  edit: (id) ->
    event = new CPP.Models.Event id: id
    event.fetch
      success: ->
        new CPP.Views.Events.Edit model: event
      error: ->
        notify "error", "Couldn't fetch event"

  view: (id) ->
    event = new CPP.Models.Event id: id
    event.fetch
      success: ->
        event.company = new CPP.Models.Company id: event.get 'company_id'
        event.company.fetch
          success: ->
            new CPP.Views.Events.View model: event
          error: ->
            notify "error", "Couldn't fetch company for event"
      error: ->
        notify "error", "Couldn't fetch event"
