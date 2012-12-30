class CPP.Routers.Departments extends Backbone.Router
  routes:
    'departments/:id/settings':   'settings'
    'department_settings' :       'settings'
    'departments/:id/dashboard':  'dashboard'
    'department_dashboard' :      'dashboard'

  settings: (id) ->
    department = @getDepartmentFromID id
    unless department
      notify 'error', 'Invalid department'
    else
      department.fetch
        success: ->
          new CPP.Views.Departments.Settings model: department
        error: ->
          notify "error", "Couldn't fetch department"

  dashboard: (id) ->
    department = @getDepartmentFromID id
    unless department
      notify 'error', 'Invalid department'
    else
      department.fetch
        success: ->
          new CPP.Views.Departments.Dashboard model: department
        error: ->
          notify 'error', "Couldn't fetch department"

  getDepartmentFromID: (id) ->
    if id?
      return new CPP.Models.Department id: id
    else if CPP.CurrentUser.get('type') == 'DepartmentAdministrator'
      return new CPP.Models.Department id: CPP.CurrentUser.get('department_id')
    else
      return false
