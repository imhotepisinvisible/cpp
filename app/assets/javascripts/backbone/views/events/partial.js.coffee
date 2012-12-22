CPP.Views.Events ||= {}

class CPP.Views.Events.Partial extends CPP.Views.Base
  template: JST['backbone/templates/events/partial']

  initialize: () ->
    @editable = @editable? && @editable
    @collection.bind('reset', @addAll)
    @render()

  addTopThree: () ->
    _.each(@collection.first(3), @addOne)

  addOne: (placement) =>
    view = new CPP.Views.Events.PartialItem
      model: placement
      editable: @options.editable
    @$("#events").append(view.render().el)

  render: () ->
    @$el.html(@template(company: @options.company, editable: @options.editable))
    if @collection.length > 0
      @addTopThree()
    else
      @$('#events').html("No events right now!")
    @
