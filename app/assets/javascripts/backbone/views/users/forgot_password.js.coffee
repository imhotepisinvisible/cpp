CPP.Views.Users ||= {}

# Password reset page
class CPP.Views.Users.ForgotPassword extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/users/forgot_password']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitPassword'

  # Initialise password reset form and call render
  initialize: ->
    @initForm()
    @render()

  # Render template and call render form
  render: ->
    $(@el).html(@template())
    super
    @renderForm()
    @

  # Initialise the form by defining its schema
  initForm: ->
    @form = new Backbone.Form
      schema:
        email: "Text"
    .render()

  # Render the form and validate individual fields
  renderForm: ->
    $('.form').html(@form.el)
    validateField(@form, field) for field of @form.fields

  # Submit the password change 
  submitPassword: ->
   if @form.validate() == null
    data = @form.getValue()
    # Clear the form before sending data
    @initForm()
    @renderForm()
    $.ajax
      url: "/users/forgot_password"
      data: data
      type: 'PUT'
      success: (data) ->
        notify "success", "Password reset", 2000
        setTimeout(
          -> window.location = '/'
        , 2500)
      error: (data) ->
        response = JSON.parse data.responseText
        if response.errors
          window.displayErrorMessages response.errors
        else
          notify 'error', 'Unable to change password'

