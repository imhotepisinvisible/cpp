class CPP.Routers.Students extends Backbone.Router
  routes:
      'students': 'index'
      'students/new': 'signupNoLogin'
      'students/:id': 'view'
      'students/:id/edit': 'edit'
      'students/:id/settings': 'settings'
      'departments/:id/students/signup': 'signup'
      'students/:id/dashboard': 'dashboard'

      'edit': 'edit'
      'profile_preview': 'view'
      'settings': 'settings'
      'register': 'signup' 

  # Student index
  index: ->
    if isStudent()
      window.history.back()
      return false
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
    if isCompanyAdmin()
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

     # Student dashboard
  dashboard: (id) ->
    # student = @getStudentFromID(id)
    # student.fetch
    #   error: ->
    #     notify "error", "Couldn't fetch student"    
    # new CPP.Views.Students.Dashboard collection: student.events    
    # student.events.fetch  
    #   error: ->
    #     notify "error", "Couldn't fetch "
    student = @getStudentFromID(id)
    unless student
      notify "error", "Invalid Student"    
    student.fetch
      error: ->
        notify "error", "Couldn't fetch student"    
    new CPP.Views.Students.Dashboard model: student    
    # Fetch 3 events and placements for dashboard
    student.events.fetch({ data: $.param({ limit: 10 , start_date: moment().toISOString()}) })
    student.placements.fetch({ data: $.param({ limit: 10, deadline: moment().toISOString()}) })



#if not isStudent()
#      window.history.back()
#      return false


  
  #  # Student dashboard
  # dashboard: (id) ->
  #   if not isStudent()
  #     window.history.back()
  #     return false
  #   events = new CPP.Collections.Events
  #   newitems = new CPP.Collections.Placements
  #   events.fetch
  #     success: -> 
  #       newitems.fecth
  #          success: -> 
  #            newitems.add(events.toJSON())    
  #            new CPP.Views.Students.Dashboard collection: newitems
  #          error: ->
  #            notify "error", "Couldn't fetch opportunities"
  #     error: ->
  #       notify "error", "Couldn't fetch events"
            
