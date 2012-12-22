class CPP.Routers.Placements extends Backbone.Router
  routes:
      'placements'                            : 'index'
      'companies/:company_id/placements'      : 'indexCompany'
      'companies/:company_id/placements/new'  : 'new'
      'placements/:id/edit'                   : 'edit'
      'placements/:id'                        : 'view'

  indexCompany: (company_id) ->
    placements = new CPP.Collections.Placements
    # new CPP.Views.Placements.Index collection: placements
    placements.fetch
      data:
        $.param({ company_id: company_id})
      success: ->
        placements.company = new CPP.Models.Company id: company_id
        placements.company.fetch
          success: ->
            new CPP.Views.Placements.Index collection: placements
          error: ->
            notify "error", "Couldn't fetch company for placement"
      error: ->
        notify "error", "Couldn't fetch placements"

  index: ->
    placements = new CPP.Collections.Placements
    placements.fetch
      success: ->
        new CPP.Views.Placements.Index collection: placements
      error: ->
        notify "error", "Couldn't fetch placements"

  new: (company_id) ->
    placement = new CPP.Models.Placement company_id: company_id
    placement.collection = new CPP.Collections.Placements
    placement.company = new CPP.Models.Company id: company_id
    placement.company.fetch
      success: ->
        placement.company.departments = new CPP.Collections.Departments
        placement.company.departments.fetch
          data:
            $.param({ company_id: placement.company.id})
          success: ->
            new CPP.Views.Placements.Edit model: placement
      error: ->
        notify "error", "Couldn't fetch company for event"

  edit: (id) ->
    placement = new CPP.Models.Placement id: id
    placement.fetch
      success: ->
        new CPP.Views.Placements.Edit model: placement
      error: ->
        notify "error", "Couldn't fetch placement"

  view: (id) ->
    placement = new CPP.Models.Placement id: id
    placement.fetch
      success: ->
        placement.company = new CPP.Models.Company id: placement.get 'company_id'
        placement.company.fetch
          success: ->
            new CPP.Views.Placements.View model: placement
          error: ->
            notify "error", "Couldn't fetch company for placement"
      error: ->
        notify "error", "Couldn't fetch placement"
