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
        @model.collection.remove(@model)
      error: =>
        notify 'error', "Could not approve request"

  reject: ->
    reject_reason = $('#reject_reason').val()
    $.ajax
      url: "/emails/#{@model.id}/reject"
      type: 'PUT'
      data:
        reject_reason: reject_reason
      success: =>
        notify 'success', "Request rejected"
        @model.collection.remove(@model)
      error: =>
        notify 'error', "Could not reject request"

