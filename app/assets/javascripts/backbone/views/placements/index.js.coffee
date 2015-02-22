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
    @collection.on "fetch", (->
        @$('#placements-table').html "<div class=\"loading\"></div>"
        return), @
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderPlacements, @
    @editable = isAdmin()
    @render()

  # Render placement template, placements and filters
  render: ->
    $(@el).html(@template(placements: @collection, editable: @editable))
    @renderPlacements(@collection)
    @renderFilters()
  @

  # Remove all placements then for each placement in the collection
  # passed in render the placement
  renderPlacements: (col) ->
    @$('#placements').html("")
    col.each (placement) =>
      view = new CPP.Views.Placements.Item(model: placement, editable: @editable)
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
        default: moment().format(getDateFormat()) #'dd/MM/yyyy'
        scope: ''},
        {name: "Company"
        type: "text"
        attribute: "company_name"
        scope: ''},
        {name: "Position"
        type: "text"
        attribute: "position"
        scope: ''},
        {name: "Location"
        type: "text"
        attribute: "location"
        scope: ''}
      ]
      data: @collection
    @

  # Navigate to the placements associated company
  viewCompany: ->
    if @collection.company
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)

