class CPP.Views.PlacementsIndex extends CPP.Views.Base
  el: '#app'
  template: JST['placements/index']

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .btn-add"              : "addPlacement"
    'click .company-logo-header'  : 'viewCompany'

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderPlacements, @

    @render()

  render: ->
    lcompanies = []
    ready = $.Deferred()
    $(@el).html(@template(placements: @collection))
    @collection.each (event) =>
      event.company = new CPP.Models.Company id: event.get("company_id")
      event.company.fetch
        success: =>
          lcompanies.push(event.company)
          if (lcompanies.length == @collection.length)
            ready.resolve()
        error: ->
          notify "error", "Couldn't fetch company for placement"
          ready.resolver()
    ready.done =>
      @renderPlacements(@collection)
      @renderFilters()   
  @

  renderPlacements: (col) ->
    @$('#placements').html("")
    col.each (placement) ->
      view = new CPP.Views.PlacementsItem model: placement
      @$('#placements').append(view.render().el)
  @

  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#placement-filter')
      filters: [
        {name: "Position Search"
        type: "text"
        attribute: "position"
        scope: ""},
        {name: "Location Search"
        type: "text"
        attribute: "location"
        scope: ""},
        {name: "Company"
        type: "text"
        attribute: "name"
        scope: ".company"
        },
        {name: "tags"
        type: "tags"
        attrublute: null
        scopy: null
        }
      ]
      data: @collection
  @

  addPlacement: ->
    Backbone.history.navigate("companies/" + @collection.company.id + "/placements/new", trigger: true)

  viewCompany: ->
    if @collection.company 
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
    
