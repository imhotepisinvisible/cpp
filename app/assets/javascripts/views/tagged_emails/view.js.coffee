class CPP.Views.TaggedEmailsView extends CPP.Views.Base
  el: "#app"
  template: JST['emails/view']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(email: @model))
    @