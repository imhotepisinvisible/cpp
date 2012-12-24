class CPP.Routers.Students extends Backbone.Router
  routes:
      'students': 'index'
      'students/:id': 'view'
      'students/:id/edit': 'edit'
      'students/:id/settings': 'settings'
      'departments/:id/students/signup': 'signup'

      'dashboard': 'edit'
      'profile_preview': 'view'
      'settings': 'settings'
      'register': 'signup'

  index: ->
    students = new CPP.Collections.Students
    students.fetch
      success: ->
        new CPP.Views.Students.Index collection: students
      error: ->
        notify "error", "Couldn't fetch students"

  view: (id) ->
    student = @getStudentFromID(id)
    unless student
      notify "error", "Invalid Student"
    student.fetch
      success: ->
        new CPP.Views.Students.View model: student
      error: ->
        notify "error", "Couldn't fetch student"


  edit: (id) ->
    student = @getStudentFromID(id)
    unless student
      notify "error", "Invalid Student"
    deferreds = []
    deferreds.push(student.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(student.placements.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(->
      companydeferreds = []
      for e in student.events.models
        do (e) ->
          e.company = new CPP.Models.Company id: e.get 'company_id'
          companydeferreds.push(e.company.fetch())
      for p in student.placements.models
        do (p) ->
          p.company = new CPP.Models.Company id: p.get 'company_id'
          companydeferreds.push(p.company.fetch())

      $.when.apply($, companydeferreds).done(->
        student.fetch
          success: ->
            new CPP.Views.Students.Edit model: student
          error: ->
            notify "error", "Couldn't fetch student"
      )
    )

  settings: (id) ->
    student = @getStudentFromID(id)
    unless student
      notify "error", "Invalid Student"
    student.events.fetch({ data: $.param({ limit: 3}) })
    student.placements.fetch({ data: $.param({ limit: 3}) })
    student.fetch
      success: ->
        new CPP.Views.Students.Settings model: student
      error: ->
        notify "error", "Couldn't fetch student"

  signup: ->
    student = new CPP.Models.Student
    student.collection = new CPP.Collections.Students
    new CPP.Views.Students.Signup model: student

  getStudentFromID: (id) ->
    if id?
      return new CPP.Models.Student id: id
    else if CPP.CurrentUser.get('type') == 'Student'
      return CPP.CurrentUser
    else
      return false
