CPP.Views.Students ||= {}

# Profile Warnings
class CPP.Views.Students.ProfileWarnings extends CPP.Views.Base
  template: JST['backbone/templates/students/profile_warnings']

  # Bind change to call render
  initialize: ->
    @model.bind 'change', @render, @

  # Render the tamplate
  render: ->
    if @model.get("first_name")
      $(@el).html(@template(model: @model))
    @
