class CPP.Views.CompaniesIndex extends CPP.Views.Base
  el: "#app"
  template: JST['companies/index']

  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    # bind to model change so backbone view update on destroy    
    @collection.bind 'destroy', @render, @
    @render()

  render: ->
    $(@el).html(@template())

    @collection.each (company) =>
      view = new CPP.Views.CompaniesItem model: company
      @$('#companies').append(view.render().el)
    @
