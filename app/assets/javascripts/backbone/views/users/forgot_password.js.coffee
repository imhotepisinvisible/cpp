CPP.Views.Users ||= {}

class CPP.Views.Users.ForgotPassword extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/users/forgot_password']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitEvent'

  initialize: ->
    @form = new Backbone.Form(
      schema:
        email: "Text"
    ).render()
    @render()

  render: ->
    $(@el).html(@template())
    super
    $('.form').append(@form.el)
    @form.on "change", =>
      @form.validate()
    @

  submitEvent: ->
   if @form.validate() == null
    data = @form.getValue()
    $.ajax
      url: "/users/forgot_password"
      data: data
      type: 'PUT'
      success: (data) ->
        notify "success", "Password changed"
      error: (data) ->
        response = JSON.parse data.responseText
        if response.errors
          window.displayErrorMessages response.errors
        else
          notify 'error', 'Unable to change password'

