CPP.Views.Emails ||= {}

# Email viewer
class CPP.Views.Emails.View extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/emails/view']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(email: @model))
    @
