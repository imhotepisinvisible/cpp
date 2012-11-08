class CPP.Routers.Students extends Backbone.Router
  routes:
      'students': 'index'
      'students/:id': 'view'
      'students/:id/edit': 'edit'
      'departments/:id/students/signup': 'signup'

  index: ->
    students = new CPP.Collections.Students
    students.fetch
      success: ->
      error: ->
        notify "error", "Couldn't fetch students"

  view: (id) ->
    student = new CPP.Models.Student id: id
    student.events.fetch({ data: $.param({ limit: 3}) })
    student.placements.fetch({ data: $.param({ limit: 3}) })

    student.fetch
      success: ->
        new CPP.Views.StudentsView model: student
      error: ->
        notify "error", "Couldn't fetch student"


  edit: (id) ->
    student = new CPP.Models.Student id: id
    student.events.fetch({ data: $.param({ limit: 3}) })
    student.placements.fetch({ data: $.param({ limit: 3}) })

    student.fetch
      success: ->
        console.log student
        new CPP.Views.StudentsEdit model: student
      error: ->
        notify "error", "Couldn't fetch student"

  signup: (department_id) ->
    student = new CPP.Models.Student department_id: department_id
    student.collection = new CPP.Collections.Students
    new CPP.Views.StudentsSignup model: student
