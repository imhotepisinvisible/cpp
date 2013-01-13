CPP.Views.Stats ||= {}

class CPP.Views.Stats.AuditItemPartial extends CPP.Views.Base
  initialize: ->
    @populate()

  # Fetches audit items and on success renders stats
  populate: ->
    @audit_items = new CPP.Collections.AuditItems
    @audit_items.fetch
      success: =>
        @render()

  # For each audit item displays the statistics partial
  render: ->
    @$el.html('')
    @audit_items.each (item) =>
      view = new CPP.Views.Stats.AuditItemPartialItem(model: item)
      @$el.append(view.render().el)
    @

