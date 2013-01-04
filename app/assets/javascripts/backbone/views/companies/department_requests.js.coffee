CPP.Views.Companies ||= {}

class CPP.Views.Companies.DepartmentRequests extends CPP.Views.Base
  template: JST['backbone/templates/companies/department_requests']

  initialize: (options) ->
    @company = options.company
    depts = new CPP.Collections.Departments
    depts.fetch
      success: =>
        @collection = depts
        @render()
      error: ->
        notify 'error', 'Could not fetch departments'

  render: ->
    $(@el).html(@template(company: @company))
    if @collection.length > 0
      @collection.each (dept) =>
        view = new CPP.Views.Companies.DepartmentRequest
          model: dept
          company: @company
        @$('#departments').append(view.render().el)
    else
      @$('#departments').append "No departments!"