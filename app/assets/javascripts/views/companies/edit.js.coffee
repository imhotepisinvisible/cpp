class CPP.Views.CompaniesEdit extends CPP.Views.Base
  el: "#app"
  template: JST['companies/edit']

  events:
    'click #name-container': 'nameEdit'
    'blur #name-input-container': 'nameStopEdit'

  initialize: ->
    @model.bind 'change', @render, @
    @render()

  render: ->
    $(@el).html(@template(company: @model))

    new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events
      editable: true

    new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements
      editable: true

    new CPP.Views.EmailsPartial
      el: $(@el).find('#emails-partial')
      model: @model
      collection: @model.emails
      editable: true
    @

  nameEdit: ->
    window.inPlaceEdit @model, 'company', 'name'

  nameStopEdit: ->
    window.inPlaceStopEdit @model, 'company', 'name', 'Click here to add a name!', _.identity

  descriptionEdit: ->
    window.inPlaceEdit @model, 'company', 'description'

  descriptionStopEdit: ->
    window.inPlaceStopEdit @model, 'company', 'description', 'Click here to add a description!', ((desc) ->
      desc.replace(/\n/g, "<br/>"))