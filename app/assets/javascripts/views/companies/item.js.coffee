class CPP.Views.CompaniesItem extends CPP.Views.Base
  tagName: "tr"
  template: JST['companies/item']

  initialize: ->
    # bind to model change so backbone view update on destroy
    @model.bind 'change', @render, @
  
  events: -> _.extend {}, CPP.Views.Base::events, 
    "click .btn-edit"   : "editCompany"
    "click .btn-delete" : "deleteCompany"
    "click"             : "viewCompany"

  render: ->
    $(@el).html(@template(company: @model))
    @

  editCompany: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("companies/" + @model.id + "/edit", trigger: true)

  deleteCompany: (e) ->
    $(e.target).parent().parent().remove();
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Company deleted"
      error: (model, response) ->
        notify "error", "Company could not be deleted"

  viewCompany: ->
    Backbone.history.navigate("companies/" + @model.id, trigger: true)
