CPP.Views.Students ||= {}

# Student settings page
class CPP.Views.Students.Settings extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/settings']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click #delete-student' : 'deleteStudent'

  # Setup skill and interest rejection tags
  # Define profile activation and tooltip activation buttons
  # Call to render
  initialize: ->
    #Auxhillary function, saves model on tag input
    saveTagModel = ->
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          # notify "success", "Updated Profile TAG"
        error: (model, response) ->
          # Notify tag-specific errors here (profanity etc)
          errorlist = JSON.parse response.responseText
          notify "error", "Couldn't Update Tags"

    @reject_skill_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'reject_skill_list'
      title: "Skills"
      url: '/tags/reject_skills'
      tag_class: 'label-success'
      tag_change_callback: saveTagModel
      additions: true

    @reject_interest_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'reject_interest_list'
      title: "Interests"
      url: '/tags/reject_interests'
      tag_class: 'label-warning'
      tag_change_callback: saveTagModel
      additions: true

    @render()

    # Set up tooltip switch
    $('#tooltip-switch').toggleButtons(
      onChange: (el, status, e) =>
        stateText = if status then 'on' else 'off'
        @model.set 'tooltip', status
        @model.save {},
          wait: true
          forceUpdate: true
          success: (model, response) =>
            notify 'success', "Switched #{stateText} helpful tooltips"
          error: (model, response) =>
            notify 'error', "Unable to switch #{stateText} helpful tooltips"
    )

    # Set up tooltip switch
    $('#active-switch').toggleButtons(
      onChange: (el, status, e) =>
        stateText = if status then 'on' else 'off'
        @model.set 'active', status
        @model.save {},
          wait: true
          forceUpdate: true
          success: (model, response) =>
            notify 'success', "Switched #{stateText} showing profile to companies and students"
          error: (model, response) =>
            notify 'error', "Unable to switch #{stateText} showing profile to companies and students"
    )

  # Render student settings and rejection tags
  render: ->
    $(@el).html(@template(student: @model))

    new CPP.Views.Users.ChangePassword
      el: $(@el).find('#change-password')
    .render()

    @reject_skill_list_tags_form.render()
    $('.reject_skill-tags-form').append(@reject_skill_list_tags_form.el)
    @reject_interest_list_tags_form.render()
    $('.reject_interest-tags-form').append(@reject_interest_list_tags_form.el)
    super

  # Delete student on confirmation
  deleteStudent: (e) ->
    if confirm "Are you sure you wish to delete your profile?\nThis cannot be undone."
      $.ajax
        url: "/students/#{@model.id}"
        type: 'DELETE'
        success: (data) ->
          window.location = '/'
        error: (data) ->
          notify('error', "Couldn't delete your account!\nPlease contact administrator.")
