class CPP.Views.CompanyTile extends CPP.Views.Base
  template: JST['companies/tile']

  events:
    "click .company-tile" : "viewCompany"

  initialize: (options) ->
    if options.big
      @template = JST['companies/top_tile']
    @render()

  render: ->
    $(@el).html(@template(company: @model))

  viewCompany: (e) ->
    Backbone.history.navigate('companies/' + @model.id, trigger: true)