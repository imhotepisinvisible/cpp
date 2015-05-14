class CPP.Routers.Placements extends Backbone.Router
  routes:
      'opportunities'                            : 'index'
      'companies/:company_id/opportunities'      : 'indexCompany'
      'companies/:company_id/opportunities/new'  : 'new'
      'opportunities/new'                        : 'newAdmin'
      'opportunities/:id/edit'                   : 'edit'
      'opportunities/:id'                        : 'view'

  # Placements index for specific company
  indexCompany: (company_id) ->
    placements = new CPP.Collections.Placements
    new CPP.Views.Placements.Index collection: placements
    placements.fetch
      error: ->
        notify "error", "Couldn't fetch placements"

  # Placements index
  index: ->
    placements = new CPP.Collections.PlacementsPager
    new CPP.Views.Placements.Index collection: placements
    placements.fetch({ data: $.param({deadline: moment().toISOString()}) })
      error: ->
        notify "error", "Couldn't fetch placements"

  # New placement
  new: (company_id) ->
    if isStudent()
      window.history.back()
      return false
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

  # New placement created by an administrator
  newAdmin: ->
    if isStudent()
      window.history.back()
      return false
    placement = new CPP.Models.Placement
    placement.collection = new CPP.Collections.Placements
    department = new CPP.Models.Department id: window.getAdminDepartment()
    department.fetch
      success: ->
        department.companies = new CPP.Collections.Companies
        department.companies.fetch
          data:
            $.param({ department_id: window.getAdminDepartment() })
          success: =>
            new CPP.Views.Placements.Edit model: placement, department: department
          error: ->
            notify "error", "Couldn't fetch department companies"
      error: ->
        notify "error", "Couldn't fetch department"

  # Edit a placement
  edit: (id) ->
    if isStudent()
      window.history.back()
      return false
    placement = new CPP.Models.Placement id: id
    placement.fetch
      success: ->
        new CPP.Views.Placements.Edit model: placement
      error: ->
        notify "error", "Couldn't fetch placement"

  # Placement view
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
