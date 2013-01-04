CPP.Views.Departments ||= {}

class CPP.Views.Departments.Approval extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/departments/approval']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-approve' : 'approve'
    'click .btn-reject'  : 'reject'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(company: @model))
    @

  approve: ->
    console.log 'approve!'

  reject: ->
    console.log 'reject!'