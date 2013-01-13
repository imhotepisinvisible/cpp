CPP.Views.Placements ||= {}

# Partial view for top 5
class CPP.Views.Stats.TopPartial extends CPP.Views.Base

	# Set template and render
  initialize: () ->
    @itemTemplate  = @options.itemTemplate
    @render()

  # Append each item with the corresponding template
  render: () ->
    @$el.html('')
    @collection.each (model) =>
      @$el.append(@itemTemplate(model: model))
    @
