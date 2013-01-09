class CPP.Views.CompaniesItem extends CPP.Views.Base
  tagName: "tr"
  template: JST['backbone/templates/companies/item']

  initialize: ->
    # bind to model change so backbone view update on destroy
    @editable = @options.editable
    @model.bind 'change', @render, @

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .button-company-edit"   : "editCompany"
    "click .button-company-reject" : "reject"
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

  reject: (e) ->
    e.stopPropagation()
    @changeStatus -1, 'rejected, consider emailing this company to explain why.'

  changeStatus: (status, message) ->
    $.ajax
      url: "/companies/#{@model.id}/departments/#{getAdminDepartment()}/status"
      type: 'PUT'
      data:
        status: status
      success: =>
        notify 'success', "Company #{message}"
        @model.collection.remove(@model)
      error: ->
        notify 'error', "Company could not be #{message}"

  viewCompany: ->
    Backbone.history.navigate("companies/" + @model.id, trigger: true)
