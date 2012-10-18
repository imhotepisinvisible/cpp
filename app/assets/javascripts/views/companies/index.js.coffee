class CPP.Views.CompaniesIndex extends Backbone.View
  el: "#app"
  template: JST['companies/index']

  events:
    "click .filterbutton" : "testFunc"

  testFunc: ->
    console.log("hi") 

  initialize: ->
    @collection.bind 'reset', @render, @

  render: ->
    $(@el).html(@template())

    @collection.each (company) =>
      view = new CPP.Views.CompaniesItem model: company
      @$('#companies').append(view.render().el)
    @

