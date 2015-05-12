class CPP.Routers.Students extends Backbone.Router
  routes:
      'students': 'index'
      'students/new': 'signupNoLogin'
      'students/:id': 'view'
      'students/:id/edit': 'edit'
      'students/:id/settings': 'settings'
      'departments/:id/students/signup': 'signup'

      'dashboard': 'dashboard'
      'edit': 'edit'
      'profile_preview': 'view'
      'settings': 'settings'
      'register': 'signup'

  # Student index
  index: ->
    students = new CPP.Collections.Students
    new CPP.Views.Students.Index collection: students
    students.fetch
      error: ->
        notify "error", "Couldn't fetch students"

  # Student profile
  view: (id) ->
    student = @getStudentFromID(id)
    unless student
      notify "error", "Invalid Student"
    student.fetch
      success: ->
        new CPP.Views.Students.View model: student
      error: ->
        notify "error", "Couldn't fetch student"

  # Student edit
  edit: (id) ->
    if isCompanyAdmin() or (id and isStudent())
      window.history.back()
      return false

    student = @getStudentFromID(id)
    unless student
      notify "error", "Invalid Student"

    student.fetch
      error: ->
        notify "error", "Couldn't fetch student"

    new CPP.Views.Students.Edit model: student

    # Fetch 3 events and placements for dashboard
    student.events.fetch({ data: $.param({ limit: 3 , start_date: moment().toISOString()}) })
    student.placements.fetch({ data: $.param({ limit: 3, deadline: moment().toISOString()}) })

  # Student administration page
  admin: (id) ->
    student = new CPP.Models.Student id: id
    student.fetch
      success: ->
        new CPP.Views.Students.Admin model: student
      error: ->
        notify "error", "Couldn't fetch student"

  # Student settings page
  settings: (id) ->
    student = @getStudentFromID(id)
    unless student
      notify "error", "Invalid Student"
    #These aren't even on the settings page, so why are they being fetched?
    #student.events.fetch({ data: $.param({ limit: 3}) })
    #student.placements.fetch({ data: $.param({ limit: 3}) })
    student.fetch
      success: ->
        new CPP.Views.Students.Settings model: student
      error: ->
        notify "error", "Couldn't fetch student"

  signup: ->
    @register true

  signupNoLogin: ->
    @register false

  # Register a new student
  register: (login) ->
    if login && CPP.CurrentUser? && CPP.CurrentUser isnt {}
      window.history.back()
      return false
    student = new CPP.Models.Student
    student.collection = new CPP.Collections.Students
    new CPP.Views.Students.Signup
      model: student
      login: login

  getStudentFromID: (id) ->
    if id?
      return new CPP.Models.Student id: id
    else if CPP.CurrentUser.get('type') == 'Student'
      return CPP.CurrentUser
    else
      return false

  #Student dashboard
  dashboard: ->
    events = new CPP.Collections.EventsRecent
    events.fetch({async:false})
    placements = new CPP.Collections.PlacementsRecent
    placements.fetch({async:false})
    events.add(placements.toJSON())
    new CPP.Views.Students.Dashboard collection: events
