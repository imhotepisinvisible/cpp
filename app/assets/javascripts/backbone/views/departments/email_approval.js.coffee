CPP.Views.Departments ||= {}

class CPP.Views.Departments.EmailApproval extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/departments/email_approval']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-approve' : 'approve'
    'click .btn-reject'  : 'reject'

  initialize: (options) ->
    @render()

  render: ->
    $(@el).html(@template(email: @model))
    @

  approve: ->
    $.ajax
      url: "/emails/#{@model.id}/approve"
      type: 'PUT'
      success: =>
        notify 'success', "Request approved"
        $(@el).remove()
      error: =>
        notify 'error', "Could not approve request"

  reject: ->
    reject_reason = $('#reject_reason').val()
    console.log reject_reason
    $.ajax
      url: "/emails/#{@model.id}/reject"
      type: 'PUT'
      data:
        reject_reason: reject_reason
      success: =>
        notify 'success', "Request rejected"
        $(@el).remove()
      error: =>
        notify 'error', "Could not reject request"

