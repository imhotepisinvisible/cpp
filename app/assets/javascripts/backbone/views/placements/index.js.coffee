CPP.Views.Placements ||= {}

# Placement view
class CPP.Views.Placements.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/placements/index']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .company-logo-header'  : 'viewCompany'

  # Bind to update placement collection
  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderPlacements, @
    @render()

  # For each placement fetch the corresponding company
  # Render placements and filters
  render: ->
    lcompanies = []
    ready = $.Deferred()
    $(@el).html(@template(placements: @collection, editable: isAdmin()))
    @collection.each (placement) =>
      placement.company = new CPP.Models.Company id: placement.get("company_id")
      placement.company.fetch
        success: =>
          lcompanies.push(placement.company)
          if (lcompanies.length == @collection.length)
            ready.resolve()
        error: ->
          notify "error", "Couldn't fetch company for placement"
          ready.resolver()
    ready.done =>
      @renderPlacements(@collection)
      @renderFilters()
    @

  # Remove all placements then for each placement in the collection
  # passed in render the placement
  renderPlacements: (col) ->
    @$('#placements').html("")
    col.each (placement) ->
      view = new CPP.Views.Placements.Item model: placement
      @$('#placements').append(view.render().el)
    @

  # Define the filters to render
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

  # Navigate to the placements associated company
  viewCompany: ->
    if @collection.company
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)

