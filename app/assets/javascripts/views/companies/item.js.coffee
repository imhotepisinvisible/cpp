class CPP.Views.CompaniesItem extends Backbone.View
  tagName: "tr"
  template: JST['companies/item']
  
  initialize: ->
    @model.bind 'change', @render, @
  
  events: 
    "click .btn-edit" : "editCompany"
    "click .btn-delete" : "deleteCompany"

  render: ->
    $(@el).html(@template(company: @model))
    @

  editCompany: ->
    console.log("edit company " + @model.get("name"))
    @model.set {name : "EDIT"}
    Backbone.sync "update", @model

  deleteCompany: ->
    console.log("delete company " + @model.get("name"))
    @model.destroy