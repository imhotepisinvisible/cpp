CPP.Views.Departments ||= {}

class CPP.Views.Departments.CompanyApproval extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/departments/company_approval']

  initialize: (options) ->
    @dept = options.dept
    @render()

  render: ->
    $(@el).html(@template(company: @model))
    @