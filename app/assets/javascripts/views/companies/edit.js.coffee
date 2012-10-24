class CPP.Views.CompaniesEdit extends Backbone.View
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
      collection: @model.events
    
    new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      collection: @model.placements

    @

  editCompany: ->
    @model.set {name : "EDIT"}
    @model.save
      wait: true
