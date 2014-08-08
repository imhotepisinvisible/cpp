class CPP.Models.Student extends CPP.Models.Base
  initialize: ->
    @events = new CPP.Collections.Events
    @events.url = '/students/' + this.id + '/events'

    @placements = new CPP.Collections.Placements
    @placements.url = '/students/' + this.id + '/placements'

    @allDepartments = new CPP.Collections.Departments
    @allDepartments.url = '/departments'

    @courses = new CPP.Collections.Courses

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
    departments:
      required: true
    year:
      pattern: 'number'

  schema: ->
    first_name:
      type: "Text"
      title: "First Name*"
    last_name:
      type: "Text"
      title: "Last Name*"
    departments:
      type: "Checkboxes"
      title: "Department(s)*"
      options: @allDepartments
      editorClass: "departments-checkbox"
    email:
      type: "Text"
      title: "Email*"
    password:
      type: "Password"
      title: "Password*"
      validators: [passwordLength = (value, formValues) ->
        err =
          type: "password"
          message: "Password must be at least 8 characters long"

        err  if value.length < 8
      ]
    password_confirmation:
      type: "Password"
      title: "Password Confirmation*"
      validators:
        [
          type: 'match'
          field: 'password'
          message: 'Passwords do not match'
        ]

  reasonsProfileInactive: ->
    reasons = []
    reasons.push("You have set your profile to be inactive in your Account Settings") unless @get('active')
    reasons.push("You need to add your first name")   if @get('first_name') == null || @get('first_name') == ''
    reasons.push("You need to add your last name")    if @get('last_name') == null || @get('last_name') == ''
    reasons.push("You need to add your degree")       if @get('degree') == null || @get('degree') == ''
    reasons.push("You need to add your current year") if @get('year') == null || @get('year') == '' || @get('year') == 0
    reasons.push("You need to add your C.V")          if @get('cv_file_name') == null || @get('cv_file_name') == ''
    return reasons

class CPP.Collections.Students extends CPP.Collections.Base
  url: '/students'
  model: CPP.Models.Student
