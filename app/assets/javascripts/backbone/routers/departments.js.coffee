class CPP.Routers.Departments extends Backbone.Router
  routes:
    'departments/:id/settings':   'settings'
    'department_settings' :       'settings'
    'departments/:id/dashboard':  'dashboard'
    'department_dashboard' :      'dashboard'
    'departments/:id/register' :  'register'
    'departments/:id/readonlyregister' :  'readonlyregister'
    'departments/:id/insights' :  'insights'
    'insights'     :  'insights'

  # Department setting spage
  settings: (id) ->
    if isStudent() or isCompanyAdmin()
      window.history.back()
      return false

    department = @getDepartmentFromID id
    unless department
      notify 'error', 'Invalid department'
    else
      department.fetch
        success: ->
          new CPP.Views.Departments.Settings model: department
        error: ->
          notify "error", "Couldn't fetch department"

  # Department dashboard
  dashboard: (id) ->
    if isStudent() or isCompanyAdmin()
      window.history.back()
      return false

    department = @getDepartmentFromID id
    unless department
      notify 'error', 'Invalid department'
    else
      new CPP.Views.Departments.Dashboard model: department
      department.fetch
        error: ->
          notify 'error', "Couldn't fetch department"

  # Department administrator registration page - add new admin to
  # existing department
  register: (id) ->
    if isStudent() or isCompanyAdmin()
      window.history.back()
      return false

    department = @getDepartmentFromID id
    unless department
      notify 'error', 'Invalid department'
    else
      department.fetch
        success: ->
          new CPP.Views.DepartmentAdministrator.Register
            dept: department
            model: new CPP.Models.DepartmentAdministrator
        error: ->
          notify 'error', "Couldn't fetch department"

  readonlyregister: (id) ->
    if isStudent() or isCompanyAdmin()
      window.history.back()
      return false

    department = @getDepartmentFromID id
    unless department
      notify 'error', 'Invalid department'
    else
      department.fetch
        success: ->
          new CPP.Views.DepartmentAdministrator.Readonlyregister
            dept: department
            model: new CPP.Models.ReadonlyAdministrator
        error: ->
          notify 'error', "Couldn't fetch department"

  # Return the department using id provided, or logged in user
  getDepartmentFromID: (id) ->
    if id?
      return new CPP.Models.Department id: id
    else if isDepartmentAdmin()
      return new CPP.Models.Department id: CPP.CurrentUser.get('department_id')
    else
      return false

  # Statistics page
  insights: (id) ->
    if isStudent() or isCompanyAdmin()
      window.history.back()
      return false

    department = @getDepartmentFromID id
    unless department
      notify 'error', 'Invalid department'
    else
      department.fetch
        success: ->
          new CPP.Views.Departments.Insights model: department
        error: ->
          notify 'error', "Couldn't fetch department"
