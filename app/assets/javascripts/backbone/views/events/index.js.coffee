CPP.Views.Events ||= {}

class CPP.Views.Events.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/events/index']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #events-table tbody tr'          : 'viewEvent'

  # Bind reset and filter events to render and renderEvents so that on change
  # the views change.
  initialize: ->
    #display ajax spinner whilst waiting for the collection to finish loading
    #@collection.on "fetch", (->
    #	@$('#events-table').append "<div class=\"loading\"></div>"
    #	return), @
    #@collection.bind 'reset', @render, @
    @editable = isAdmin()
    @render()

  # Render events
  render: ->
    event_columns = [
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
        name: 'title'
        label: 'Event'
        cell: 'string'
        editable: false
      }
      {
        name: 'start_date'
        label: 'Date'
        cell: Backgrid.Extension.MomentCell.extend({
          displayFormat: "DD/MM/YYYY"
        })
        editable: false
      }
      {
        name: 'location'
        label: 'Location'
        cell: 'string'
        editable: false
      }
      {
        name: 'spaces'
        label: 'Spaces Remaining'
        #http://stackoverflow.com/questions/20093844/backgrid-formatter-adding-values-from-other-columns/20233521
        cell: Backgrid.Cell.extend(render: ->
          capacity = @model.get('capacity')
          @$el.text capacity
          # MUST do this for the grid to not error out
          @
        )
        editable: false
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
    admin_columns = _.union(event_columns,hidden_columns)

    $(@el).html(@template(events: @collection, editable: @editable))

    if isDepartmentAdmin()
      eventGrid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow
        columns: admin_columns
        collection: @collection)
    else
      eventGrid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow
        columns: event_columns
        collection: @collection)
        #emptyText: "No data to display")
        #footer: Backgrid.Extension.Infinator.extend(scrollToTop: false))

    # Render the grid and attach the root to your HTML document
    $table = $('#events-table')
    $table.append eventGrid.render().el

    # Initialize the paginator
    paginator = new (Backgrid.Extension.Paginator)(collection: @collection)
    # Render the paginator
    $table.after paginator.render().el

    # Initialize a client-side filter to filter on the client
    # mode pageable collection's cache.
    filter = new (Backgrid.Extension.ClientSideFilter)(
      collection: @collection
      fields: [ 'company_logo_url', 'title', 'start_date', 'location', 'status' ])
    # Render the filter
    $table.before filter.render().el
  @

  viewEvent: (e) ->
    model = $(e.target).parent().data('model')
    Backbone.history.navigate("events/" + model.id, trigger: true)
