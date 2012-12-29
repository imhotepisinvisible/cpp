CPP.Views.Users ||= {}

class CPP.Views.Users.ChangePassword extends CPP.Views.Base

  template: JST['backbone/templates/users/change_password']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-password-save' : 'savePassword'
    'click #btn-password-cancel' : 'cancelPassword'

  initialize: ->
    @passwordForm = new Backbone.Form
      schema:
        old_password:
          type: "Password"
          title: "Old Password"
        password:
          type: "Password"
          title: "New Password"
        password_confirmation:
          type: "Password"
          title: "Confirm New Password"
          validators:
            [
              type: 'match'
              field: 'password'
              message: 'Passwords do not match'
            ]
    .render()
    @passwordForm.on "change", =>
      @passwordForm.validate()
    @

  render: ->
    $(@el).html(@template())
    $('#password-form').html(@passwordForm.el)

  cancelPassword: (e) ->
    @initialize()
    @render()

  savePassword: (e) ->
    if @passwordForm.validate() == null
      data = @passwordForm.getValue()

      $.ajax
        url: "/users/change_password"
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