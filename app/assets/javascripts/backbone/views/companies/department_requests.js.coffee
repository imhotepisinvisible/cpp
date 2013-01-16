CPP.Views.Companies ||= {}

class CPP.Views.Companies.DepartmentRequests extends CPP.Views.Base
  template: JST['backbone/templates/companies/department_requests']

  # Partial for department requests (for company dashboard)
  initialize: (options) ->
    @company = options.company
    depts = new CPP.Collections.Departments
    depts.url = "/companies/#{@company.id}/departments"
    depts.fetch
      data: {show_all: 1}
      success: =>
        @collection = depts
        @render()
      error: ->
        notify 'error', 'Could not fetch departments'

  # Render department requests
  render: ->
    $(@el).html(@template(company: @company))
    if @collection.length > 0
      # Create department request partial for each request
      @collection.each (dept) =>
        view = new CPP.Views.Companies.DepartmentRequest
          model: dept
          company: @company
        @$('#departments').append(view.render().el)
    else
      @$('#departments').append "No departments!"
