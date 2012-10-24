class CPP.Routers.Companies extends Backbone.Router
  routes:
      'companies': 'index'
      'companies/:id': 'view'
      'companies/:id/edit': 'edit'

  index: ->
    companies = new CPP.Collections.Companies
    new CPP.Views.CompaniesIndex(
      collection: companies
      router: @
    )
    companies.fetch()

  view: (id) ->
    companies = new CPP.Collections.Companies
    companies.fetch(
      success: ->
        new CPP.Views.CompaniesView model: companies.get(id)
      error: ->
        console.log "Couldn't fetch companies"
    )

  edit: (id) ->
    companies = new CPP.Collections.Companies
    companies.fetch(
      success: ->
        new CPP.Views.CompaniesEdit model: companies.get(id)
      error: ->
        console.log "Couldn't fetch companies"
    )

  companiesedit: (id) ->
  	companies = new CPP.Collections.Companies
  	companies.fetch(
  		success: ->
  			new CPP.Views.CompaniesEdit model: companies.get(id)
  		error: ->
  			console.log "error"
  	)
