class CPP.Views.CompaniesEdit extends CPP.Views.Base
  el: "#app"
  template: JST['companies/edit']

  events:
    "click .btn-edit" : "editCompany"

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

    new CPP.Emails.PlacementsPartiail
      el: $(@el).find('#emails-partial')
      model: @model
      collection: @model.emails
      editable: true
    @

  editCompany: ->
    @model.set {name : "EDIT"}
    @model.save
      wait: true
