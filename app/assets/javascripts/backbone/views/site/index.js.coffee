CPP.Views.Site ||= {}

# Site index page 
class CPP.Views.Site.Index extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/site/index']

  # From initialise call render of the index
  initialize: ->
    @render()

  # Render the index page from the template
  render: ->
    $(@el).html(@template(student: @model))
    super
    @
