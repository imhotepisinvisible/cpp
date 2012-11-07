class CPP.Routers.Students extends Backbone.Router
  routes:
      'students': 'index'
      'students/:id': 'view'
      'students/:id/edit': 'edit'

  index: ->
    students = new CPP.Collections.Students
    students.fetch
      success: ->
        console.log students
      error: ->
        notify "error", "Couldn't fetch students"

  view: (id) ->
    student = new CPP.Models.Student id: id
    student.events.fetch({ data: $.param({ limit: 3}) })
    student.placements.fetch({ data: $.param({ limit: 3}) })

    student.fetch
      success: ->
        console.log student
        new CPP.Views.StudentsView model: student
      error: ->
        notify "error", "Couldn't fetch student"


  edit: ->
