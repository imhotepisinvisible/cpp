CPP.Views.Students ||= {}

# Dashboard for students
class CPP.Views.Students.Dashboard extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/students/dashboard']

  initialize: ->
    @collection.on "fetch", (->
    	@$('#dashboard-table').append "<div class=\"loading\"></div>"
    	return), @
    @collection.bind 'reset', (->
    	@$('.loading').remove()
    	return), @
    @editable = isAdmin()
    @render()

  render: ->
    columns = [
      {
        name: 'type'
        label: 'Type'
        cell: Backgrid.Cell.extend(render: ->
          if @model.get('title')
            itemtype = 'Event'
          else
            itemtype = 'Opportunity'
          @$el.text itemtype
          @
        )
        editable: false
        sortValue: (model, sortKey) ->
          if model.get('title')
            return 'Event'
          else
            return 'Opportunity'
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
        name: 'title'
        label: 'Title'
        cell: Backgrid.Cell.extend(render: ->
          if @model.get('title')
            itemname = @model.get('title')
          else
            itemname = @model.get('position')
          @$el.text itemname
          @
        )
        editable: false
        sortValue: (model, sortKey) ->
          if model.get('title')
            return model.get('title').toLowerCase()
          else
            return model.get('position').toLowerCase()
      }
      {
        name: 'Date/Deadline'
        label: 'Date/Deadline'
        cell: Backgrid.Cell.extend(render: ->
          if @model.get('title')
            itemdate = moment(@model.get('start_date')).fromNow()
          else
            itemdate = moment(@model.get('deadline')).fromNow()
          @$el.text itemdate
          @
        )
        editable: false
        sortValue: (model, sortKey) ->
          if model.get('title')
            return model.get('start_date')
          else
            return model.get('deadline')
      }
      {
        name: "created_at"
        label: "Posted"
        cell: Backgrid.Cell.extend(render: ->
          posted = moment(@model.get('created_at')).fromNow()
          @$el.text posted
          @
        )
        editable: false
        sortValue: (model, sortKey) ->
          return model.get('created_at')
      }
    ]

    $(@el).html(@template(events: @collection, editable: @editable))
    dashboardGrid = new (Backgrid.Grid)(
      className: "backgrid table-hover table-clickable",
      row: ModelRow
      columns: columns
      collection: @collection)

    # Render the grid and attach the root to your HTML document
    $table = $('#dashboard-table')
    #dashboardGrid.render().sort("Posted","descending")
    $table.append @dashboardGrid.render.el
  @
