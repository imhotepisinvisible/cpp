CPP.Views.Departments ||= {}

class CPP.Views.Departments.CompanyApproval extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/departments/company_approval']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-approve' : 'approve'
    'click #btn-reject'  : 'reject'

  initialize: (options) ->
    @dept = options.dept
    @render()

  render: ->
    $(@el).html(@template(company: @model))
    @

  approve: ->
    @changeStatus 2, 'approved'

  reject: ->
    @changeStatus -1, 'rejected'

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
