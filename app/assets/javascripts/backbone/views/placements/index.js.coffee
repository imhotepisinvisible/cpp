CPP.Views.Placements ||= {}

class CPP.Views.Placements.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/placements/index']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .company-logo-header'  : 'viewCompany'

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderPlacements, @
    @render()

  render: ->
    lcompanies = []
    ready = $.Deferred()
    $(@el).html(@template(placements: @collection, editable: isAdmin()))
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
      view = new CPP.Views.Placements.Item model: placement
      @$('#placements').append(view.render().el)
    @

  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#placement-filter')
      filters: [
        {name: "Tags"
        type: "tags"
        attribute: ["skill_list", "interest_list", "year_group_list"]
        scope: ''},
        {name: "Deadline After",
        type: 'date',
        attribute: 'deadline'
        default: Date.today().toString('yyyy-MM-dd')
        scope: ''},
        {name: "Company"
        type: "text"
        attribute: "name"
        scope: ".company"},
        {name: "Position"
        type: "text"
        attribute: "position"
        scope: ""},
        {name: "Location"
        type: "text"
        attribute: "location"
        scope: ""}
      ]
      data: @collection
    @

  viewCompany: ->
    if @collection.company
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)

