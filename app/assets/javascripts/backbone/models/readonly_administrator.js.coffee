class CPP.Models.ReadonlyAdministrator extends CPP.Models.Base
  initialize: ->
    @allDepartments = new CPP.Collections.Departments
    @allDepartments.url = '/departments'

  url: ->
    '/readonly_administrators' + (if @isNew() then '' else '/' + @id)

  validation:
    first_name:
      required: true
    last_name:
      required: true
    email:
      required: true
      pattern: 'email'
    password:
      required: true
      minLength: 8
    password_confirmation:
      required: true
      minLength: 8

  schema: ->
    first_name:
      type: "Text"
      title: "First Name*"
    last_name:
      type: "Text"
      title: "Last Name*"
    email:
      type: "Text"
      title: "Email*"
    password:
      type: "Password"
    password_confirmation:
      type: "Password"
      title: "Password Confirmation*"
      validators:
        [
          type: 'match'
          field: 'password'
          message: 'Passwords do not match'
        ]

class CPP.Collections.ReadonlyAdministrators extends CPP.Collections.Base
  model: CPP.Models.ReadonlyAdministrator
  url: '/readonly_administrators'
