class CPP.Views.CompaniesSettings extends CPP.Views.Base
  el: "#app"
  template: JST['companies/settings']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #delete-company' : 'deleteCompany'
    'click #btn-password-save' : 'savePassword'
    'click #btn-password-cancel' : 'cancelPassword'

  initialize: ->
    @initPasswordForm()
    @render()

  initPasswordForm: ->
    @passwordForm = new Backbone.Form 
      model: @model
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
    $(@el).html(@template(company: @model))
    @renderPasswordForm()

  renderPasswordForm: ->
    $('#password-form').html(@passwordForm.el)

  deleteCompany: (e) ->
    if confirm "Are you sure you wish to delete your profile?\nThis cannot be undone."
      $.ajax
        url: "/companies/#{@model.id}"
        type: 'DELETE'
        success: (data) ->
          Backbone.history.navigate('/')
        error: (data) ->
          notify('error', "Couldn't delete your account!\nPlease contact administrator.")

  cancelPassword: (e) ->
    @initPasswordForm()
    @renderPasswordForm()

  savePassword: (e) ->
    if @passwordForm.validate() == null
      data = @passwordForm.getValue()
      data.email = 'test@test.test' # TODO get logged in company's email address

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
