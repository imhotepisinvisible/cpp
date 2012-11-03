class CPP.Routers.Students extends Backbone.Router
  routes:
      'students': 'index'
      'students/:id': 'view'
      'students/:id/edit': 'edit'

  index: ->
  	console.log "index!"

  view: (id) ->
    student = new CPP.Models.Student id: id
    console.log student
    student.fetch
      success: ->
        new CPP.Views.StudentsView model: student
      error: ->
        notify "error", "Couldn't fetch student"

  edit: ->
    console.log "edit!"