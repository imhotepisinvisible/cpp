CPP.Views.Placements ||= {}

# Placements partial for top three placements
class CPP.Views.Placements.Partial extends CPP.Views.Base
  template: JST['backbone/templates/placements/partial']

  # Set editable and the company associated with the placement
  # Render the placement
  initialize: () ->
    @editable = @options.editable? && @options.editable
    @company  = @options.company
    @collection.bind('reset', @addAll)
    @render()

  # For the first three placements, call addOne
  addTopThree: () ->
    _.each(@collection.first(3), @addOne)

  # Append the placement
  addOne: (placement) =>
    view = new CPP.Views.Placements.PartialItem
      model: placement
      editable: @options.editable
    @$("#placements").append(view.render().el)

  # Render placement partial tamplate and populate three placements
  # If there are no placements then display no placement message
  render: () ->
    @$el.html(@template(company: @company, editable: @editable))
    if @collection.length > 0
      @addTopThree()
    else
      @$('#placements').html("No opportunities right now!")
    @
