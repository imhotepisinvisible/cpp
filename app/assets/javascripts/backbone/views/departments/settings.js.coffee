CPP.Views.Departments ||= {}

class CPP.Views.Departments.Settings extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/settings']

  events: -> _.extend {}, CPP.Views.Base::events

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(department: @model))

    new CPP.Views.Users.ChangePassword
      el: $(@el).find('#change-password')
      model: @model
    .render()