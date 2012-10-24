class CPP.Views.CompaniesEdit extends Backbone.View
  el: "#app"
  template: JST['companies/edit']
    

  initialize: ->
    #@model.bind 'change', @render, @
    @render()

  render: ->
    $(@el).html(@template(company: @model))
    @

  log: ->
    console.log "logging!!"
