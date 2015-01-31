class CPP.Routers.Students extends Backbone.Router
  routes:
      'students': 'index'
      'students/new': 'signupNoLogin'
      'students/:id': 'view'
      'students/:id/edit': 'edit'
      'students/:id/settings': 'settings'
      'departments/:id/students/signup': 'signup'

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

  # Student dashboard
  edit: (id) ->
    if isCompanyAdmin()
      window.history.back()
      return false

    student = @getStudentFromID(id)
    unless student
      notify "error", "Invalid Student"         
                             
    # Fetch 3 events and placements for dashboard
    deferreds = []     
    now = new Date() 
    deferreds.push(student.events.fetch({ data: $.param({ limit: 3 , start_date: now.toISOString()}) }))
    deferreds.push(student.placements.fetch({ data: $.param({ limit: 3, deadline: now.toISOString()}) }))

    $.when.apply($, deferreds).done(->
      companydeferreds = []
      #Fetch company for each event and placement
      for e in student.events.models
        do (e) ->
          e.company = new CPP.Models.Company id: e.get 'company_id'
          companydeferreds.push(e.company.fetch())
      for p in student.placements.models
        do (p) ->
          p.company = new CPP.Models.Company id: p.get 'company_id'
          companydeferreds.push(p.company.fetch())

      $.when.apply($, companydeferreds).done(->
          # Fetch the student when we're done
          student.fetch
            success: ->
              new CPP.Views.Students.Edit model: student
            error: ->
              notify "error", "Couldn't fetch student"
      )
    ) 
       
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
      #Theses aren't even on the settings page, so why are they being fetched?
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

                  
