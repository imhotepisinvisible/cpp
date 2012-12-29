class CPP.Models.Student extends Backbone.Model
  initialize: ->
    @events = new CPP.Collections.Events
    @events.url = '/students/' + this.id + '/events'

    @placements = new CPP.Collections.Placements
    @placements.url = '/students/' + this.id + '/placements'

    @allDepartments = new CPP.Collections.Departments
    @allDepartments.url = '/departments'

  url: ->
    '/students' + (if @isNew() then '' else '/' + @id)

  validation:
    first_name:
      required: true
    last_name:
      required: true
    email:
      required: true
      pattern: 'email'
    password:
      minLength: 8
    password_confirmation:
      minLength: 8

  schema: ->
    first_name:
      type: "Text"
      title: "First Name"
    last_name:
      type: "Text"
      title: "Last Name"
    departments:
      type: "Checkboxes"
      options: @allDepartments
      editorClass: "departments-checkbox"
      validators: ['required']
    email:
      type: "Text"
      title: "Email"
    password:
      type: "Password"
      validators: ['required']
    password_confirmation:
      type: "Password"
      title: "Password Confirmation"
      validators:
        [
          type: 'match'
          field: 'password'
          message: 'Passwords do not match'
        ]

class CPP.Collections.Students extends CPP.Collections.Base
  url: '/students'
  model: CPP.Models.Student
