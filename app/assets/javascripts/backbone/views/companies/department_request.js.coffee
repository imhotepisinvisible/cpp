CPP.Views.Companies ||= {}

class CPP.Views.Companies.DepartmentRequest extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/companies/department_request']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-request'   : 'request'

  initialize: (options) ->
    @company = options.company
    @render()

  render: ->
    $(@el).html(@template(dept: @model, status: @statusMap(@model.get 'status')))
    @

  statusMap: (code) ->
    switch code
      when -1
        'Rejected'
      when 0
        'Not requested'
      when 1
        'Pending approval'
      when 2
        'Approved'
      else
        code

  request: ->
    # Rejected or not requested
    if @model.get('status') < 1
      $.ajax
        url: "/companies/#{@company.id}/departments/#{@model.id}/apply"
        type: 'PUT'
        success: ->
          notify 'success', 'Request sent'
          $('.request-status').html('Pending approval')
          $('.btn-container').hide()