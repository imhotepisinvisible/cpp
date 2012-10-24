class CPP.Routers.Companies extends Backbone.Router
  routes:
      'companies': 'index'
      'companies/:id': 'view'
      'companies/:id/edit': 'edit'

  index: ->
    companies = new CPP.Collections.Companies
    new CPP.Views.CompaniesIndex
      collection: companies
    companies.fetch()

  view: (id) ->
    company = new CPP.Models.Company id: id
    company.fetch
      success: ->
        new CPP.Views.CompaniesView model: company
      error: ->
        notify "error", "Couldn't fetch companies"

  edit: (id) ->
    company = new CPP.Models.Company id: id
    company.fetch
      success: ->
        new CPP.Views.CompaniesEdit model: company
      error: ->
        notify "error", "Couldn't fetch companies"
