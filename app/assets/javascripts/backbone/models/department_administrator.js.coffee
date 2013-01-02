class CPP.Models.DepartmentAdministrator extends CPP.Models.Base
  initialize: ->
    @allDepartments = new CPP.Collections.Departments
    @allDepartments.url = '/departments'

  validation:
    first_name:
      required: true
    last_name:
      required: true
    departments:
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
    departments:
      type: "Checkboxes"
      title: "Departments*"
      options: @allDepartments
      editorClass: "departments-checkbox"
    email:
      type: "Text"
      title: "Email*"
    password:
      type: "Password"
    password_confirmation:
      type: "Password*"
      title: "Password Confirmation*"
      validators:
        [
          type: 'match'
          field: 'password'
          message: 'Passwords do not match'
        ]

class CPP.Collections.DepartmentAdministrators extends CPP.Collections.Base
  model: CPP.Models.DepartmentAdministrator
