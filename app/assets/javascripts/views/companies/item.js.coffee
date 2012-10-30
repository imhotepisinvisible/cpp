class CPP.Views.CompaniesItem extends CPP.Views.Base
  tagName: "tr"
  template: JST['companies/item']

  initialize: ->
    # bind to model change so backbone view update on destroy
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
      success: (model, response) ->
        notify "success", "Company deleted"
      error: (model, response) ->
        notify "error", "Company could not be deleted"
