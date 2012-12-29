CPP.Views.Events ||= {}

class CPP.Views.Events.Partial extends CPP.Views.Base
  template: JST['backbone/templates/events/partial']

  initialize: () ->
    @editable = @options.editable
    @company  = @options.company
    @editable = @editable? && @editable
    @collection.bind('reset', @addAll)
    @render()

  addTopThree: () ->
    _.each(@collection.first(3), @addOne)

  addOne: (event) =>
    view = new CPP.Views.Events.PartialItem
      model: event
      editable: @editable
    @$("#events").append(view.render().el)

  render: () ->
    @$el.html(@template(company: @company, editable: @editable))
    if @collection.length > 0
      @addTopThree()
    else
      @$('#events').html("No events right now!")
    @
