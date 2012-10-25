class CPP.Routers.Companies extends Backbone.Router
  routes:
      'companies': 'index'
      'companies/:id': 'view'
      'companies/:id/edit': 'edit'

  index: ->
    companies = new CPP.Collections.Companies
    companies.fetch
      success: ->
        new CPP.Views.CompaniesIndex collection: companies
      error: ->
        notify "error", "Couldn't fetch companies"

  view: (id) ->
    company = new CPP.Models.Company id: id
    company.fetch
      success: ->
        new CPP.Views.CompaniesView model: company
      error: ->
        notify "error", "Couldn't fetch company"

  edit: (id) ->
    company = new CPP.Models.Company id: id
    company.fetch
      success: ->
        new CPP.Views.CompaniesEdit model: company
      error: ->
        notify "error", "Couldn't fetch company"
