class CPP.Views.CompaniesIndex extends Backbone.View
  el: "#app"
  template: JST['companies/index']

  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    @collection.bind 'destroy', @render, @

  render: ->
    $(@el).html(@template())

    @collection.each (company) =>
      view = new CPP.Views.CompaniesItem model: company
      @$('#companies').append(view.render().el)
    @