CPP.Views.Placements ||= {}

# Placement view
class CPP.Views.Placements.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/placements/index']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    #'click .company-logo-header'  : 'viewCompany'
    'click tr'                    : 'viewCompany'

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
    columns = [
      {
        name: ''
        cell: 'select-row'
        headerCell: 'select-all'
      }
      {
        name: 'company_logo_url'
        label: 'Company'
        editable: false
        cell: 'image'
      }
      {
        name: 'position'
        label: 'Position'
        cell: 'string'
        editable: false
      }
      {
        name: 'deadline'
        label: 'Deadline'
        cell: 'date'
        editable: false
      }
      {
        name: 'location'
        label: 'Location'
        cell: 'string'
        editable: false
      }
      {
        name: 'created_at'
        label: 'Posted'
        cell: 'string'
        editable: false
      }      
      {
        name: 'workflow_state'
        label: 'Status'
        cell: 'string'
        editable: false
      }
    ]
    $(@el).html(@template(placements: @collection, editable: @editable))
    @renderFilters()
    grid = new (Backgrid.Grid)(
      className: "backgrid table-hover table-clickable",
      row: ModelRow
      columns: columns
      collection: @collection.fullCollection
      footer: Backgrid.Extension.Infinator.extend(scrollToTop: false))
      
    # Render the grid and attach the root to your HTML document
    $table = $('#placements-table')
    $table.append grid.render().el
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
  viewCompany: (e) ->
    model = $(e.target).parent().data('model')
    Backbone.history.navigate("companies/" + model.get('company_id'), trigger: true)

