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
    console.log("model render")
    @
    

  editCompany: ->
    console.log(@model)
    @model.set {name : "EDIT"}
    @model.save
      wait: true

  deleteCompany: ->
    console.log("delete company " + @model.get("name"))
    @model.destroy
      wait: true