class CPP.Views.CompaniesItem extends CPP.Views.Base
  tagName: "tr"
  template: JST['backbone/templates/companies/item']

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .button-company-edit"   : "editCompany"
    "click .button-company-reject" : "reject"
    "click .button-company-contacts-edit" : 'editContacts'
    "click"                        : "viewCompany"

  # Individual company item in index
  initialize: ->
    # Bind to model change so backbone view update on destroy
    @editable = @options.editable
    @model.bind 'change', @render, @

  render: ->
    $(@el).html(@template(company: @model, editable: @editable))
    @

  # Edit company button click
  editCompany: (e) ->
    # Prevent event from triggering click on item to navigate to view
    e.stopPropagation()
    Backbone.history.navigate("companies/" + @model.id + "/edit", trigger: true)

  # Edit contacts button click
  editContacts: (e) ->
    # Prevent event from triggering click on item to navigate to view
    e.stopPropagation()
    Backbone.history.navigate("companies/#{@model.id}/company_contacts/edit", trigger: true)

  # Company reject button
  reject: (e) ->
    # Prevent event from triggering click on item to navigate to view
    e.stopPropagation()
    @changeStatus CPP_APPROVAL_STATUS.REJECTED, 'rejected, consider emailing this company to explain why.'

  # Change approval status of company
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

  # Navigate to company view
  viewCompany: ->
    Backbone.history.navigate("companies/" + @model.id, trigger: true)
