class CPP.Views.CompanyTile extends CPP.Views.Base
  template: JST['companies/tile']

  retrieveTemplate: ->
  	@template(company: @model)