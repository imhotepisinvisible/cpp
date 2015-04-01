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
    @editable = isAdmin()
    @render()



  # Render new items
  render: ->
    $(@el).html(@template(student: @model))
    #$(@el).html(@template(events: @collection, editable: @editable))
    #@renderItems(@collection)
    #
    events_partial = new CPP.Views.Events.Partial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events
      

    placements_partial = new CPP.Views.Placements.Partial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements
  @


  # Render each event item
  renderItems: (col) ->
    @events = col
    @$('#items').html("")
    col.each (event) =>
      view = new CPP.Views.Students.DashboardItem(model: event, editable: @editable)
      @$('#items').append(view.render().el)
    @
