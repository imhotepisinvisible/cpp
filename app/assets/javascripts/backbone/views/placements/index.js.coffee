CPP.Views.Placements ||= {}

# Placement view
class CPP.Views.Placements.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/placements/index']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click #placements-table tbody tr'       : 'viewPlacement'

  # Bind to update placement collection
  initialize: ->
    @collection.on "fetch", (->
    	@$('.loading').show()
    	return), @
    @collection.bind 'reset', (->
    	@$('.loading').hide()
    	return), @
    @editable = isAdmin()
    @render()

  # Render placement template, placements and filters
  render: ->
    placement_columns = [
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
        sortValue: (model, sortKey) ->
          return model.get('company_name').toLowerCase()
      }
      {
        name: 'position'
        label: 'Position'
        cell: 'string'
        editable: false
        sortValue: (model, sortKey) ->
          return model.get('position').toLowerCase()
      }
      {
        name: 'deadline'
        label: 'Deadline'
        cell: Backgrid.Cell.extend(render: ->
          deadline = moment(@model.get('deadline')).fromNow()
          @$el.text deadline
          @
        )
        editable: false
        sortValue: (model, sortKey) ->
          return model.get('deadline')
      }
      {
        name: 'location'
        label: 'Location'
        cell: 'string'
        editable: false
        sortValue: (model, sortKey) ->
          return model.get('location').toLowerCase()
      }
      {
        name: 'created_at'
        label: 'Posted'
        cell: Backgrid.Cell.extend(render: ->
          posted = moment(@model.get('created_at')).fromNow()
          @$el.text posted
          @
        )
        editable: false
        sortValue: (model, sortKey) ->
          return model.get('created_at')
      }]
    hidden_columns = [
      {
        name: 'workflow_state'
        label: 'Status'
        cell: 'string'
        editable: false
      }
      {
        cell: EditCell
      }
      {
        cell: DeleteCell
      }
    ]
    admin_columns = _.union(placement_columns,hidden_columns)

    $(@el).html(@template(placements: @collection, editable: @editable))

    if isDepartmentAdmin()
      placementGrid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow
        columns: admin_columns
        collection: @collection)
    else
      placementGrid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow
        columns: placement_columns
        collection: @collection)

    # Render the grid and attach the root to your HTML document
    $table = $('#placements-table')
    $table.append placementGrid.render().el

    # Initialize the paginator
    paginator = new (Backgrid.Extension.Paginator)(collection: @collection)
    # Render the paginator
    $table.after paginator.render().el

    # Initialize a client-side filter to filter on the client
    # mode pageable collection's cache.
    filter = new (Backgrid.Extension.ClientSideFilter)(
      collection: @collection
      fields: [ 'company_logo_url', 'position', 'deadline', 'location', 'status' ])
    # Render the filter
    $table.before filter.render().el
  @

  # Navigate to the placements associated company
  viewPlacement: (e) ->
    model = $(e.target).parent().data('model')
    Backbone.history.navigate("opportunities/" + model.id, trigger: true)
