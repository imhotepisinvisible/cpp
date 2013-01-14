CPP.Views.Companies ||= {}

class CPP.Views.Companies.EditAdministrators extends CPP.Views.Base
  
  template: JST['backbone/templates/companies/edit_admins']

  # Initialise a set of company administrator edit views
  initialize: (options) ->
    @company = options.company
    @header = options.header
    admins = new CPP.Collections.CompanyAdministrators
    admins.fetch
      data: $.param({ company_id: @company.id })
      success: =>
        @collection = admins
        @render()
      error: =>
        notify 'error', 'Could not fetch company administrators'

  # Render the set of company administrator edit views
  render: ->
    $(@el).html(@template(company: @company, header: @header))
    if @collection.length > 0
      # Render a company admin edit view for each in the collection
      @collection.each (admin) =>
        view = new CPP.Views.Companies.EditAdministrator
          model: admin
        @$('#admins').append(view.render().el)
    else
      @$('#admins').append "No administrators!"