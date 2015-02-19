class CPP.Views.CompaniesStudentIndex extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/student_index']
  rowDiv: '<div class="row" id="current-tile-row"></div>'

  # Company index for students
  initialize: (options) ->
    @collection.on "fetch", (->
        @$('#company-tiles').html "<div class=\"loading\"></div>"
        return), @
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    @collection.bind 'filter', @renderCompanies, @
    @render()

  # Render company index for students
  render: ->
    $(@el).html(@template())
    @renderCompanies(@collection)
    @renderFilters()
    super
    @

  # Render the companies in tiles
  renderCompanies: (collection) ->
    @collection.sort()
    $('#company-tiles').html("")
    # Sort collection by rating (has to be done before bind to reset)
    if collection.length > 0
      # First company in top position
      $('#company-tiles').append('<div id="company-tile-container-0"></div>')
      topCompanyTile = new CPP.Views.CompanyTile
        model: collection.first()
        el: '#company-tile-container-0'
        big: true
      $('#company-tiles').append(@rowDiv)

      if collection.length > 1
        # All other companies in rows of three
        for index in [1..(collection.length - 1)]
          # Every third company, add a new row
          if index % 3 == 1
            $('#current-tile-row').removeAttr('id')
            $('#company-tiles').append(@rowDiv)
          $('#current-tile-row').append('<div id="company-tile-container-' + index + '"></div>')
          companyTile = new CPP.Views.CompanyTile
            model: collection.at(index)
            el: '#company-tile-container-' + index
            big: false
    @

  # Render the filters
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
