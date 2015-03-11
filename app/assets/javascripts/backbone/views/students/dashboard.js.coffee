CPP.Views.Students ||= {}

# Dashboard for students 
class CPP.Views.Students.Dashboard extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/students/dashboard']

  initialize: ->
    @collection.on "fetch", (->
    	@$('#items-table').html "<div class=\"loading\"></div>"
    	return), @
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderItems, @    
    @editable = isAdmin()
    @render()



  # Render new items
  render: ->
    $(@el).html(@template(events: @collection, editable: @editable))
    @renderItems(@collection)
  @


  # Render each event item
  renderItems: (col) ->
    @events = col
    @$('#items').html("")
    col.each (event) =>
      view = new CPP.Views.Students.DashboardItem(model: event, editable: @editable)
      @$('#items').append(view.render().el)
    @
