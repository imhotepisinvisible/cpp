CPP.Views.Events ||= {}

class CPP.Views.Events.Partial extends CPP.Views.Base
  template: JST['backbone/templates/events/partial']

  # Bind collections reset event to addAll so when reset view updates
  initialize: () ->
    @editable = @options.editable? && @options.editable
    @company  = @options.company
    @collection.on "fetch", (->
    	@$('#events').html "<div class=\"loading\"></div>"
    	return), @
    @collection.bind('reset', @render, @)
    @render()

  addTopThree: () ->
    _.each(@collection.first(3), @addOne)

  # Create partial item view for event
  addOne: (event) =>
    view = new CPP.Views.Events.PartialItem
      model: event
      editable: @editable
    @$("#events").append(view.render().el)

  # Render template view and display top three events if the collection
  # has more than one item
  render: () ->
    $(@el).html(@template(company: @company, editable: @editable))
    if @collection.length > 0
      @addTopThree()
    else
      @$('#events').html("No events right now!")
    @
