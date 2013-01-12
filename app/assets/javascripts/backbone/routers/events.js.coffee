class CPP.Routers.Events extends Backbone.Router
  routes:
      'events'                               : 'index'
      'companies/:company_id/events'         : 'indexCompany'
      'companies/:company_id/events/new'     : 'new'
      'events/:id/edit'                      : 'edit'
      'events/new'                           : 'new'
      'events/:id'                           : 'view'
      'events/:id/students'                  : 'eventAttendees'

  indexCompany: (company_id) ->
    # Events index for a specific company
    events = new CPP.Collections.Events
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
    # Events index
    events = new CPP.Collections.Events
    events.fetch
      success: ->
        deferreds = []
        events.each (event) =>
          event.registered_students = new CPP.Collections.Students()
          deferreds.push(event.registered_students.fetch({ data: $.param({ event_id: event.id }) }))
        
        $.when.apply($, deferreds).done(=>
          new CPP.Views.Events.Index collection: events
        )
      error: ->
        notify "error", "Couldn't fetch events"

  new: (company_id) ->
    # Create a new event
    if isStudent()
      window.history.back()
      return false
    if isDepartmentAdmin()
      # Redirect admin to admin event creation page
      return @newAdmin()
    unless company_id
      company_id = getUserCompanyId()

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
    # Administrator new event page
    if isStudent()
      window.history.back()
      return false
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
    # Edit an event
    unless isAdmin()
      window.history.back()
      return false
    else
      event = new CPP.Models.Event id: id
      event.fetch
        success: ->
          new CPP.Views.Events.Edit model: event
        error: ->
          notify "error", "Couldn't fetch event"

  view: (id) ->
    # View an event
    event = new CPP.Models.Event id: id
    event.fetch
      success: ->
        event.company = new CPP.Models.Company id: event.get 'company_id'
        event.registered_students = new CPP.Collections.Students()
        deferreds = []
        # Fetch company and registered students for event
        deferreds.push(event.company.fetch())
        deferreds.push(event.registered_students.fetch({ data: $.param({ event_id: id }) }))
        $.when.apply($, deferreds).done(=>
          new CPP.Views.Events.View model: event
        )
      error: ->
        notify "error", "Couldn't fetch event"

  eventAttendees: (id) ->
    # Student index for students attending the event
    event = new CPP.Models.Event id: id
    event.fetch
      success: ->
        event.company = new CPP.Models.Company id: event.get 'company_id'
        event.registered_students = new CPP.Collections.Students()
        deferreds = []
        deferreds.push(event.company.fetch())
        deferreds.push(event.registered_students.fetch({ data: $.param({ event_id: id }) }))
        $.when.apply($, deferreds).done(=>
          new CPP.Views.Students.Index collection: event.registered_students
        )
      error: ->
        notify "error", "Couldn't fetch event"