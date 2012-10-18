class CPP.Views.CompaniesItem extends Backbone.View
  tagName: "tr"
  template: JST['companies/item']

  events: 
    "click .btn-edit" : "editCompany"
    "click .btn-delete" : "deleteCompany"

  editCompany: ->
    console.log("edit company " + @model.get("name")) 

  deleteCompany: ->
    console.log("delete company " + @model.get("name")) 

  render: ->
    $(@el).html(@template(company: @model))
    @
