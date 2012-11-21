class CPP.Views.CompanyTopTile extends CPP.Views.Base
  template: JST['companies/top_tile']

  retrieveTemplate: ->
  	@template(company: @model)