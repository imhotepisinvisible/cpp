class CPP.Views.CompaniesItem extends CPP.Views.Base
  tagName: "tr"
  template: JST['backbone/templates/companies/item']

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .button-company-edit"   : "editCompany"
    "click .button-company-reject" : "reject"
    "click .button-company-contacts-edit" : 'editContacts'
    "click"                        : "viewCompany"

  initialize: ->
    # Individual company item in index
    # Bind to model change so backbone view update on destroy
    @editable = @options.editable
    @model.bind 'change', @render, @

  render: ->
    $(@el).html(@template(company: @model, editable: @editable))
    @

  editCompany: (e) ->
    # Prevent event from triggering click on item to navigate to view
    e.stopPropagation()
    Backbone.history.navigate("companies/" + @model.id + "/edit", trigger: true)

  editContacts: (e) ->
    # Prevent event from triggering click on item to navigate to view
    e.stopPropagation()
    Backbone.history.navigate("companies/#{@model.id}/company_contacts/edit", trigger: true)

  reject: (e) ->
    # Prevent event from triggering click on item to navigate to view
    e.stopPropagation()
    @changeStatus CPP_APPROVAL_STATUS.REJECTED, 'rejected, consider emailing this company to explain why.'

  changeStatus: (status, message) ->
    # Change approval status of company
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
