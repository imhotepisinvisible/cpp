class CPP.Views.StudentsSettings extends CPP.Views.Base
  el: "#app"
  template: JST['students/settings']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #delete-student' : 'deleteStudent'
    'click #btn-account-save' : 'saveAccount'
    'click #btn-account-cancel' : 'cancelAccount'

  initialize: ->
    @accountForm = new Backbone.Form
      model: @model
    .render()

    @render()

  render: ->
    $(@el).html(@template(student: @model))
    $('#account-form').html(@accountForm.el)
    @accountForm.on "change", =>
      @accountForm.validate()
    @

  deleteStudent: (e) ->
    if confirm "Are you sure you wish to delete your profile?\nThis cannot be undone."
      $.ajax
        url: "/students/#{@model.id}"
        type: 'DELETE'
        success: (data) ->
          Backbone.history.navigate('/')
        error: (data) ->
          notify('error', "Couldn't delete your account!\nPlease contact administrator.")

  cancelAccount: (e) ->
    @accountForm.render()
    $('#account-form').html(@accountForm.el)

  saveAccount: (e) ->
    if @accountForm.validate() == null
      @accountForm.commit()
      @model.save {},
        wait: true
        success: (model, response) ->
          console.log response
          console.log model
          notify "success", "Account updated"
        error: (model, response) ->
          console.log response
          console.log model
          window.displayJQXHRErrors response