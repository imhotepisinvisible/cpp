class CPP.Views.CompaniesStudentIndex extends CPP.Views.Base
  el: "#app"
  template: JST['companies/student_index']
  rowDiv: '<div class="row" id="current-tile-row"></div>'

  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    @collection.bind 'filter', @renderCompanies, @
    @render()

  render: ->
    $(@el).html(@template())
    @renderCompanies(@collection)
    @renderFilters()

  renderCompanies: (collection) ->
    console.log @collection
    $('#company-tiles').html("")

    # TODO: Sort collection by relevence to student (maybe using tags?)
    # so that best is first

    if collection.length > 0
      $('#company-tiles').append('<div id="company-tile-container-0"></div>')
      topCompanyTile = new CPP.Views.CompanyTile
        model: collection.first()
        el: '#company-tile-container-0'
        big: true
      $('#company-tiles').append(@rowDiv)

      if collection.length > 1
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