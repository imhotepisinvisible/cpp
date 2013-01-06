class CPP.Views.CompaniesItem extends CPP.Views.Base
  tagName: "tr"
  template: JST['backbone/templates/companies/item']

  initialize: ->
    # bind to model change so backbone view update on destroy
    @editable = @options.editable
    @model.bind 'change', @render, @

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .button-company-edit"   : "editCompany"
    "click .button-company-delete" : "deleteCompany"
    "click .button-company-contacts-edit" : 'editContacts'
    "click"                        : "viewCompany"

  render: ->
    $(@el).html(@template(company: @model, editable: @editable))
    @

  editCompany: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("companies/" + @model.id + "/edit", trigger: true)

  editContacts: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("companies/#{@model.id}/company_contacts/edit", trigger: true)

  deleteCompany: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        $(e.target).parent().parent().parent().parent().remove();
        notify "success", "Company deleted"
      error: (model, response) ->
        notify "error", "Company could not be deleted"

  viewCompany: ->
    Backbone.history.navigate("companies/" + @model.id, trigger: true)
