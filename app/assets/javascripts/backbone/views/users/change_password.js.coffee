CPP.Views.Users ||= {}
# Change User Password
class CPP.Views.Users.ChangePassword extends CPP.Views.Base

  template: JST['backbone/templates/users/change_password']
  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-password-save' : 'savePassword'
    'click #btn-password-cancel' : 'cancelPassword'
  # Set schema for password form
  # Render form and validate on change
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

  # Render password form 
  render: ->
    $(@el).html(@template())
    $('#password-form').html(@passwordForm.el)

  # Re initialise and render to cancel action 
  cancelPassword: (e) ->
    @initialize()
    @render()

  # Save changed password
  savePassword: (e) ->
    if @passwordForm.validate() == null
      formData = @passwordForm.getValue()
      data = {'user[email]' : window.CPP.CurrentUser.get('email'), 'user[password]' : formData['password'], 'user[password_confirmation]' : formData['password_confirmation'], 'user[current_password]' : formData['old_password']}

      $.ajax
        url: "/users"
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