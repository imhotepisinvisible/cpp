CPP.Views.Companies ||= {}

class CPP.Views.Companies.DepartmentRequest extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/companies/department_request']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-request'   : 'request'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(dept: @model))
    @

  request: ->
    console.log 'request!'