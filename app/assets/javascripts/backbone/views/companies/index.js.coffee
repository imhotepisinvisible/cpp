class CPP.Views.CompaniesIndex extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/index']

  # Company aggregate view for administrators
  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    @collection.bind 'filter', @renderCompanies, @
    @editable = isDepartmentAdmin()
    @render()

  # Render the view
  render: ->
    $(@el).html(@template(editable: @editable, companies: @collection))
    @renderCompanies(@collection)
    @renderFilters()

  # Render the companies in the collection
  renderCompanies: (col) ->
    @$('#companies').html("")
    col.each (company) =>
      view = new CPP.Views.CompaniesItem(model: company, editable: @editable)
      @$('#companies').append(view.render().el)
    @

  # Render the company filters
  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#company-filter')
      filters: [
        {name: "Name"
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
