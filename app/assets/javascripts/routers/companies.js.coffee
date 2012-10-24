class CPP.Routers.Companies extends Backbone.Router
  routes:
      'companies': 'index'
      'companies/:id': 'companiesedit'

  index: ->
    companies = new CPP.Collections.Companies
    new CPP.Views.CompaniesIndex(
    	collection: companies
    	router: @
    )
    companies.fetch()

  companiesedit: (id) ->
  	companies = new CPP.Collections.Companies
  	companies.fetch(
  		success: ->
  			new CPP.Views.CompaniesEdit model: companies.get(id)
  		error: ->
  			console.log "uh oh"
  	)