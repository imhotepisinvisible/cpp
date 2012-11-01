class CPP.Routers.Placements extends Backbone.Router
  routes:
      'placements'                            : 'index'
      'companies/:company_id/placements'      : 'indexCompany'
      'companies/:company_id/placements/new'  : 'new'
      'placements/:id/edit'                   : 'edit'
      'placements/:id'                        : 'view'

  indexCompany: (company_id) ->
    placements = new CPP.Collections.Placements
    # new CPP.Views.PlacementsIndex collection: placements
    placements.fetch
      data: 
        $.param({ company_id: company_id})
      success: ->
        placements.company = new CPP.Models.Company id: company_id
        placements.company.fetch
          success: ->
            new CPP.Views.PlacementsIndex collection: placements
          error: ->
            notify "error", "Couldn't fetch company for placement"
      error: ->
        notify "error", "Couldn't fetch placements"

  index: ->
    placements = new CPP.Collections.Placements
    placements.fetch
      success: ->
        new CPP.Views.PlacementsIndex collection: placements
      error: ->
        notify "error", "Couldn't fetch placements"

  new: (company_id) ->
    placement = new CPP.Models.Placement company_id: company_id
    placement.collection = new CPP.Collections.Placements
    new CPP.Views.PlacementsEdit model: placement

  edit: (id) ->
    placement = new CPP.Models.Placement id: id
    placement.fetch
      success: ->
        new CPP.Views.PlacementsEdit model: placement
      error: ->
        notify "error", "Couldn't fetch placement"

  view: (id) ->
    console.log id
    placement = new CPP.Models.Placement id: id
    placement.fetch
      success: ->
        placement.company = new CPP.Models.Company id: placement.get("company_id")
        placement.company.fetch
          success: ->
            new CPP.Views.PlacementsView model: placement
          error: ->
            notify "error", "Couldn't fetch company for placement"
      error: ->
        notify "error", "Couldn't fetch placement"
