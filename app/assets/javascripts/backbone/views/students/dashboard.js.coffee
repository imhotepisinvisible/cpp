CPP.Views.Students ||= {}

# Dashboard for students 
class CPP.Views.Students.Dashboard extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/students/dashboard']

  initialize: ->
    @collection.reset(@collection.first(15))
    @collection.on "fetch", (->
    	@$('#events-table').append "<div class=\"loading\"></div>"
    	return), @
    @collection.bind 'reset', @render, @    
    @editable = isAdmin()
    @first = @collection.first();
    @render()
  
  render: ->
    columns = [
      {
        name: ''
        cell: 'select-row'
        headerCell: 'select-all'
      }
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
      }      
      {
        name: 'company_logo_url'
        label: 'Company'
        editable: false
        cell: 'image'
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
      }
    ]
  
    $(@el).html(@template(events: @collection, editable: @editable, item: @first))
    grid = new (Backgrid.Grid)(
      className: "backgrid table-hover table-clickable",
      row: ModelRow
      columns: columns
      collection: @collection
      footer: Backgrid.Extension.Infinator.extend(scrollToTop: false))
      
    # Render the grid and attach the root to your HTML document
    $table = $('#events-table')
    $table.append grid.render().el
  @

  
