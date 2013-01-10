CPP.Views.Stats ||= {}

class CPP.Views.Stats.AuditItemPartial extends CPP.Views.Base
  initialize: ->
    @populate()

  populate: ->
    @audit_items = new CPP.Collections.AuditItems
    @audit_items.fetch
      success: =>
        @render()

  render: ->
    @$el.html('')
    @audit_items.each (item) =>
      view = new CPP.Views.Stats.AuditItemPartialItem(model: item)
      console.log view.render().el
      @$el.append(view.render().el)
    @

