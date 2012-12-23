CPP.Views.Students ||= {}

class CPP.Views.Students.Settings extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/settings']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #delete-student' : 'deleteStudent'
    'click #btn-password-save' : 'savePassword'
    'click #btn-password-cancel' : 'cancelPassword'

  initialize: ->
    saveTagModel = ->
      @model.save {},
        wait: true
        success: (model, response) =>
          # notify "success", "Updated Profile TAG"
        error: (model, response) ->
          # Notify tag-specific errors here (profanity etc)
          errorlist = JSON.parse response.responseText
          notify "error", "Couldn't Update Tags"

    @reject_skill_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'reject_skill_list'
      title: "Skills I don't want to hear about"
      url: '/tags/reject_skills'
      tag_class: 'label-success'
      tag_change_callback: saveTagModel
      additions: true

    @reject_interest_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'reject_interest_list'
      title: "Interests I don't want to hear about"
      url: '/tags/reject_interests'
      tag_class: 'label-warning'
      tag_change_callback: saveTagModel
      additions: true

    @initPasswordForm()
    @render()

    # Set up tooltip switch
    $('#tooltip-switch').toggleButtons(
      onChange: (el, status, e) =>
        newState = if status then 'on' else 'off'
        oldState = if status then 'off' else 'on'
        $('#switch-on-off-text').html(oldState)
        @model.set 'tooltip', status
        @model.save {},
          wait: true
          success: (model, response) =>
            notify 'success', "Switched #{newState} helpful tooltips"
          error: (model, response) =>
            notify 'error', "Unable to switch #{newState} helpful tooltips"
    )

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
    $(@el).html(@template(student: @model))
    @renderPasswordForm()
    @reject_skill_list_tags_form.render()
    $('.reject_skill-tags-form').append(@reject_skill_list_tags_form.el)
    @reject_interest_list_tags_form.render()
    $('.reject_interest-tags-form').append(@reject_interest_list_tags_form.el)
    super

  renderPasswordForm: ->
    $('#password-form').html(@passwordForm.el)

  deleteStudent: (e) ->
    if confirm "Are you sure you wish to delete your profile?\nThis cannot be undone."
      $.ajax
        url: "/students/#{@model.id}"
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
      data.email = @model.get 'email'

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
