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

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      collection: @model.events
    @

  editCompany: ->
    @model.set {name : "EDIT"}
    @model.save
      wait: true
