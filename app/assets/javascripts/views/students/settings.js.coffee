class CPP.Views.StudentsSettings extends CPP.Views.Base
  el: "#app"
  template: JST['students/settings']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #delete-student' : 'deleteStudent'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(student: @model))

  deleteStudent: (e) ->
    if confirm "Are you sure you wish to delete your profile?\nThis cannot be undone."
      $.ajax
        url: "/students/#{@model.id}"
        type: 'DELETE'
        success: (data) ->
          Backbone.history.navigate('/')
        error: (data) ->
          notify('error', "Couldn't delete your account!\nPlease contact administrator.")