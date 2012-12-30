CPP.Views.Users ||= {}

class CPP.Views.Users.ForgotPassword extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/users/forgot_password']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitEvent'

  initialize: ->
    @initForm()
    @render()

  render: ->
    $(@el).html(@template())
    super
    @renderForm()
    @

  initForm: ->
    @form = new Backbone.Form
      schema:
        email: "Text"
    .render()

  renderForm: ->
    $('.form').html(@form.el)
    @form.on "change", =>
      @form.validate()

  submitEvent: ->
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

