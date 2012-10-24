class CPP.Views.CompaniesItem extends Backbone.View
  tagName: "tr"
  template: JST['companies/item']

  initialize: (options) ->
    @router = options.router
    @model.bind 'change', @render, @
  
  events: 
    "click .btn-edit" : "editCompany"
    "click .btn-delete" : "deleteCompany"

  render: ->
    $(@el).html(@template(company: @model))
    @
    

  editCompany: ->
    Backbone.history.navigate("companies/" + @model.id + "/edit", trigger: true)

  deleteCompany: ->
    @model.destroy
      wait: true