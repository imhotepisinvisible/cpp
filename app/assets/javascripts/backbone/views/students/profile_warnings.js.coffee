CPP.Views.Students ||= {}

class CPP.Views.Students.ProfileWarnings extends CPP.Views.Base
  template: JST['backbone/templates/students/profile_warnings']

  initialize: ->
    @model.bind 'change', @render, @

  render: ->
    $(@el).html(@template(model: @model))
    @
