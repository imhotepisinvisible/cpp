CPP.Views.Departments ||= {}

class CPP.Views.Departments.Approval extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/departments/approval']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-approve' : 'approve'
    'click .btn-reject'  : 'reject'

  initialize: (options) ->
    @dept = options.dept
    @render()

  render: ->
    $(@el).html(@template(company: @model))
    @

  approve: ->
    @changeStatus 2

  reject: ->
    @changeStatus -1

  changeStatus: (status) ->
    statusText = if status == 2 then 'approve' else 'reject'
    suffix = if status == 2 then 'd' else 'ed'

    $.ajax
      url: "/companies/#{@model.id}/departments/#{@dept.id}/change_status"
      type: 'PUT'
      data:
        status: status
      success: =>
        notify 'success', "Request #{statusText}#{suffix}"
        $(@el).remove()
      error: =>
        notify 'error', "Could not #{statusText} request"