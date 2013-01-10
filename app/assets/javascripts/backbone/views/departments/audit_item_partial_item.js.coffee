CPP.Views.Stats ||= {}

class CPP.Views.Stats.AuditItemPartialItem extends CPP.Views.Base
  template: JST['backbone/templates/departments/audit_item_partial_item']

  render: () ->
    $(@el).html(@template(model: @model))
    @

