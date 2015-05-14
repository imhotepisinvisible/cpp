# All companies view
class CPP.Views.CompaniesIndex extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/index']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #companies-table tbody tr'  : 'viewCompany'

  # Company aggregate view for administrators
  # Bind to update collection
  initialize: (options) ->
    #@collection.on "fetch", (->
    #    @$('#companies-table').append "<div class=\"loading\"></div>"
    #    return), @
    #@collection.bind 'reset', @render, @
    @editable = isDepartmentAdmin()
    @render()

  # Render template with editable and company collection
  # Render companies and filters
  render: ->
    columns = [
      {
        name: ''
        cell: 'select-row'
        headerCell: 'select-all'
      }
      {
        name: 'logo_url'
        label: 'Name'
        editable: false
        cell: 'image'
        sortValue: (model, sortKey) ->
          return model.get('name').toLowerCase()
      }
      {
        name: 'description'
        label: 'Description'
        cell: 'string'
        editable: false
        sortValue: (model, sortKey) ->
          return model.get('description').toLowerCase()
      }]
    hidden_columns = [
      {
        name: 'status'
        label: 'Status'
        cell: Backgrid.Cell.extend(render: ->
          company_status = @model.getStatus()
          @$el.text company_status
          @
        )
        editable: false
      }
      {
        cell: EditCell
      }
      {
        cell: DeleteCell
      }]
    admin_columns = _.union(columns,hidden_columns)

    $(@el).html(@template(editable: @editable, companies: @collection))

    if isDepartmentAdmin()
      companyGrid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow
        columns: admin_columns
        collection: @collection)
    else
      companyGrid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow
        columns: columns
        collection: @collection)

    # Render the grid and attach the root to your HTML document
    $table = $('#companies-table')
    $table.append companyGrid.render().el

    # Initialize the paginator
    paginator = new (Backgrid.Extension.Paginator)(collection: @collection)
    # Render the paginator
    $table.after paginator.render().el

    # Initialize a client-side filter to filter on the client
    # mode pageable collection's cache.
    filter = new (Backgrid.Extension.ClientSideFilter)(
      collection: @collection
      fields: [ 'name', 'description' ])
    # Render the filter
    $table.before filter.render().el
  @

  viewCompany: (e) ->
    model = $(e.target).parent().data('model')
    Backbone.history.navigate("companies/" + model.id, trigger: true)
