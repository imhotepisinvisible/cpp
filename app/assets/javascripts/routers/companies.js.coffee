class CPP.Routers.Companies extends Backbone.Router
  routes:
      'companies': 'index'

  index: ->
    companies = new CPP.Collections.Companies
    new CPP.Views.CompaniesIndex collection: companies
    companies.fetch()
