class CPP.Views.CompaniesIndex extends CPP.Views.Base
  el: "#app"
  template: JST['companies/index']

  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    @collection.bind 'filter', @renderCompanies, @
    @render()

  render: ->
    $(@el).html(@template())
    @renderCompanies(@collection)
    @renderFilters()
   
  renderCompanies: (col) ->
    @$('#companies').html("")
    col.each (company) =>
      view = new CPP.Views.CompaniesItem model: company
      @$('#companies').append(view.render().el)
    @

  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#company-filter')
      filters: [
        {name: "Company Search"
        type: "text"
        attribute: "name"
        scope: ""
        },
        {name: "Description"
        type: "text"
        attribute: "description"
        scope: ""}
      ]
      data: @collection
  @