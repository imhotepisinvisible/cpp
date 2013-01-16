CPP.Views.Departments ||= {}

class CPP.Views.Departments.CompanyApproval extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/departments/company_approval']

  # Add event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-approve' : 'approve'
    'click #btn-reject'  : 'reject'

  # Retrives department from options and renders company approval
  initialize: (options) ->
    @dept = options.dept
    @render()

  render: ->
    $(@el).html(@template(company: @model))
    @

  approve: ->
    @changeStatus CPP_APPROVAL_STATUS.APPROVED, 'approved'

  reject: ->
    @changeStatus CPP_APPROVAL_STATUS.REJECTED, 'rejected, consider emailing this company to explain why.'

  # Changes the company status for the given department (model) to status
  changeStatus: (status, message) ->
    $.ajax
      url: "/companies/#{@model.id}/departments/#{@dept.id}/status"
      type: 'PUT'
      data:
        status: status
      success: =>
        notify 'success', "Company #{message}"
        @model.collection.remove(@model)
      error: ->
        notify 'error', "Company could not be #{message}"
