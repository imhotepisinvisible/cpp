CPP.Views.Companies ||= {}

class CPP.Views.Companies.DepartmentRequest extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/companies/department_request']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-request'   : 'request'

  initialize: (options) ->
    # Individual department request
    @company = options.company
    @render()

  render: ->
    $(@el).html(@template(dept: @model, status: approvalStatusMap(@model.get 'status')))
    @

  request: (e) ->
    # Rejected or not requested
    if @model.get('status') < 1
      $.ajax
        url: "/companies/#{@company.id}/departments/#{@model.id}/apply"
        type: 'PUT'
        success: ->
          notify 'success', 'Request sent'
          $(e.currentTarget).closest('.item').find('.request-status').html(approvalStatusMap(1))
          $(e.currentTarget).closest('.btn-container').hide()
          $(e.currentTarget).closest('.item').removeClass('missing-document')
