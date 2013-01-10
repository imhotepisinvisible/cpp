CPP.Views.Placements ||= {}

class CPP.Views.Stats.TopPartial extends CPP.Views.Base

  initialize: () ->
    @itemTemplate  = @options.itemTemplate
    @render()

  render: () ->
    @$el.html('')
    @collection.each (model) =>
      @$el.append(@itemTemplate(model: model))
    @
