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
    $('.navbar-inner').show()
    $(window).unbind('scroll');
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
    data = {}
    data['user'] = @form.getValue()
    $.ajax
      url: "/users/password.json"
      data: data
      type: 'POST'
      success: (data) ->
        notify "success", "Password reset", 2000
        setTimeout(
          -> Backbone.history.navigate("/", trigger: true)
        , 2500)
      error: (data) =>
        if data.responseText
          errorlist = JSON.parse data.responseText
          for field, errors of errorlist.errors
            if field of @form.fields
              @form.fields[field].setError(errors.join ', ')
        notify "error", "Email address not found."
