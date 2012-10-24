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
    @router.navigate("companies/" + @model.id, trigger: true)

  deleteCompany: ->
    @model.destroy
      wait: true