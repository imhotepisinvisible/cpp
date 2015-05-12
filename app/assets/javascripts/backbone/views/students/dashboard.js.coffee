CPP.Views.Students ||= {}

# Dashboard for students 
class CPP.Views.Students.Dashboard extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/students/dashboard']

  initialize: ->
    #@collection.on "fetch", (->
    #	@$('#items-table').html "<div class=\"loading\"></div>"
    #	return), @
    #@collection.bind 'reset', @render, @
    #@collection.bind 'filter', @renderItems, @
    #@collection = @model.events  
    #@collection = new CPP.Collections.Events
    #@collection.fetch({async:false})
    @collection.reset(@collection.first(15))
    @collection.on "fetch", (->
    	@$('#events-table').append "<div class=\"loading\"></div>"
    	return), @
    @collection.bind 'reset', @render, @
    #@first10 = @collection.first(10);
    #@collection.reset(@collection.first(10))    
    @editable = isAdmin()
    @first = @collection.first();
    #@second = @collection.at
    
    #@models = _.toArray(@collection)
    #@model  = _.first(@models) 
    #@models = @collection #.first(3)
    #_.each(@collection.first(3), @render)
    #@collction.add(@placements.toJSON())
    #
    @render()


  # addEvent: () ->
  #   _.each(@collection.first(1),@addOne)

  # addOne: (event) =>
  #   view = new CPP.Views.Students.PartialItem
  #     model: event
  #   @$(
  # 

  
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
          # MUST do this for the grid to not error out
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
          # MUST do this for the grid to not error out
          @
        )
        editable: false
      }
      {
        name: 'Date/Deadline'
        label: 'Date/Deadline'        
        cell: Backgrid.Cell.extend(render: ->
          if @model.get('title')
            itemdate = @model.get('start_date')
          else
            itemdate = @model.get('deadline')                      
          @$el.text itemdate
          # MUST do this for the grid to not error out
          @
        )
        editable: false
      } 
      {
        name: 'created_at'
        label: 'Posted'
        cell: 'date'
        editable: false
      }
    ]
  
    $(@el).html(@template(events: @collection, editable: @editable, item: @first))
    #@renderClosing(@collection)
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

  #renderClosing: (col) ->
    #@$('#companies').html("")
    #view = new CPP.Views.Students.ClosingItem(model: col.first())
    #@$('#companies').append(view.render().el)
    #@



  # Render new items
  #render: ->
    #$(@el).html(@template(student: @model))
    #$(@el).html(@template(events: @collection, editable: @editable))
    #@renderItems(@collection)
    #
    # events_partial = new CPP.Views.Events.Partial
    #   el: $(@el).find('#events-partial')
    #   model: @model
    #   collection: @model.events
      

    # placements_partial = new CPP.Views.Placements.Partial
    #   el: $(@el).find('#placements-partial')
    #   model: @model
    #   collection: @model.placements
    # Render events



  # # Render each event item
  # renderItems: (col) ->
  #   @events = col
  #   @$('#items').html("")
  #   col.each (event) =>
  #     view = new CPP.Views.Students.DashboardItem(model: event, editable: @editable)
  #     @$('#items').append(view.render().el)
  #   @
