CPP.Views.Companies ||= {}

class CPP.Views.Companies.EditAdministrators extends CPP.Views.Base
  
  template: JST['backbone/templates/companies/edit_admins']

  initialize: (options) ->
    @company = options.company
    @header = options.header
    admins = new CPP.Collections.CompanyAdministrators
    admins.fetch
      data: $.param({ company_id: @company.id })
      success: =>
        @collection = admins
        @render()

  render: ->
    $(@el).html(@template(company: @company, header: @header))
    if @collection.length > 0
      @collection.each (admin) =>
        view = new CPP.Views.Companies.EditAdministrator
          model: admin
        @$('#admins').append(view.render().el)
    else
      @$('#admins').append "No administrators!"