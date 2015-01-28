CPP.Views.Students ||= {}

# Student signup page
class CPP.Views.Students.Signup extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/signup']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitStudent'

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
    $('#signup-form').append(@form.el)
    Backbone.Validation.bind @form
    validateField(@form, field) for field of @form.fields
    @

  # Submit form, validate and save fields
  submitStudent: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Registered"
          if @login
            $.post '/sessions', { session: { email: @model.get('email'), password: @model.get('password') } }, (data) ->
              window.location = '/students/' + model.get('id') + '/edit'
              window.location.reload(true)
          else
            Backbone.history.navigate("/students/#{model.id}/edit", trigger: true)
        error: (model, response) =>
          if response.responseText
            errorlist = JSON.parse response.responseText
            for field, errors of errorlist.errors
              if field of @form.fields
                @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to register, please resolve issues below."
