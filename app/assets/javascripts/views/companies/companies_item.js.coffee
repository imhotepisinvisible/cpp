class CPP.Views.CompaniesItem extends Backbone.View
  tagName: "tr"
  template: JST['companies/item']

  render: ->
    $(@el).html(@template(company: @model))
    @
