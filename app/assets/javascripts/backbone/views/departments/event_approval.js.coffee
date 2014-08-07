CPP.Views.Departments ||= {}

# Grants event approvals
class CPP.Views.Departments.EventApproval extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/departments/event_approval']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-approve' : 'approve'
    'click .btn-reject'  : 'reject'

  initialize: (options) ->
    @render()

  render: ->
    $(@el).html(@template(event: @model))
    @

  # Approve an event on the server
  approve: ->
    $.ajax
      url: "/events/#{@model.id}/approve"
      type: 'PUT'
      success: =>
        notify 'success', "Request approved"
        @model.collection.remove(@model)
      error: =>
        notify 'error', "Could not approve request"

  # Reject event on the server sending the reason for reject
  reject: ->
    $.ajax
      url: "/events/#{@model.id}/reject"
      type: 'PUT'
      success: =>
        notify 'success', "Request rejected"
        @model.collection.remove(@model)
      error: =>
        notify 'error', "Could not reject request"

