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
        email:
          type: "Text"
          title: "Email Address"
        current_password:
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
      data = {}
      data['user'] = @passwordForm.getValue()
      $.ajax
        url: "/users.json"
        data: data
        type: 'PUT'
        success: (data) =>
          notify "success", "Password changed"
          @cancelPassword
        error: (data) =>
          if data.responseText
            errorlist = JSON.parse data.responseText
            for field, errors of errorlist.errors
              if field of @passwordForm.fields
                @passwordForm.fields[field].setError(errors.join ', ')
          notify "error", "Unable to change password, please resolve issues below."