CPP.Views.Placements ||= {}

class CPP.Views.Placements.Partial extends CPP.Views.Base
  template: JST['backbone/templates/placements/partial']

  initialize: () ->
    @editable = @editable? && @editable
    @collection.bind('reset', @addAll)
    @render()

  addTopThree: () ->
    _.each(@collection.first(3), @addOne)

  addOne: (placement) =>
    view = new CPP.Views.Placements.PartialItem
      model: placement
      editable: @options.editable
    @$("#placements").append(view.render().el)

  render: () ->
    @$el.html(@template(company: @options.company, editable: @options.editable))
    if @collection.length > 0
      @addTopThree()
    else
      @$('#placements').html("No placements right now!")
    @
