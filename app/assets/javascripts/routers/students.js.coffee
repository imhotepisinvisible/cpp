class CPP.Routers.Students extends Backbone.Router
  routes:
      'students': 'index'
      'students/:id': 'view'
      'students/:id/edit': 'edit'

  index: ->

  view: (id) ->
    # Temporary until student controller is implemented!
    student = new CPP.Models.Student id: id
    student.set 'name', "Jack Stevenson"
    student.set 'department', "Computing"
    student.set 'year', 3
    student.set 'degree', "MEng Computing (AI)"
    student.set 'bio', "I'm a really cool student that likes church, lifting and programming."
    student.set 'profile', 'jack_profile.jpg'

    # This won't fetch anything as student controller not implemented.
    student.events.fetch({ data: $.param({ limit: 3}) })
    student.placements.fetch({ data: $.param({ limit: 3}) })

    new CPP.Views.StudentsView model: student
    # student.fetch
    #   success: ->
    #     new CPP.Views.StudentsView model: student
    #   error: ->
    #     notify "error", "Couldn't fetch student"

  edit: ->
