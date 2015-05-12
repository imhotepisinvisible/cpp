CPP.Views.Students ||= {}

# Student signup page
class CPP.Views.Students.Signup extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/signup']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitStudent'
    'keydown' : 'enterPress'

  # If department admin then remove department from schema
  # Define signup form
  initialize: (options) ->
    @login = options.login

    if isDepartmentAdmin()
      schema = @model.schema()
      delete schema["departments"]

      @model.set('departments', [CPP.CurrentUser.get 'department_id'])
      @model.schema = -> schema

    @form = new Backbone.Form(model: @model).render()
    @render()

  # Render signup form and validate individual fields
  render: ->
    $(@el).html(@template(student: @model))
    super
    $("#splash-header").hide()
    $('.navbar-inner').show()
    $('.form').append(@form.el)
    Backbone.Validation.bind @form
    validateField(@form, field) for field of @form.fields
    @

  enterPress: (k) ->
    if k.keyCode == 13
        @submitStudent()

  # Submit form, validate and save fields
  submitStudent: ->
    if @form.validate() == null

      data = {}
      data['student'] = @form.getValue()
      $.ajax
        url: "/students.json"
        data: data
        type: 'POST'
        success: (data) ->
          notify "success", "Registered", 2000
          setTimeout(
            -> window.location = '/'
          , 2500)
        error: (data) =>
          if data.responseText
            errorlist = JSON.parse data.responseText
            for field, errors of errorlist.errors
              if field of @form.fields
                @form.fields[field].setError(errors.join ', ')
          notify "error", "Unable to register, please resolve issues below."
