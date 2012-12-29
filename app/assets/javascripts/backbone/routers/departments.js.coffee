class CPP.Routers.Departments extends Backbone.Router
  routes:
    'departments/:id/settings': 'settings'

  settings: (id) ->
    department = new CPP.Models.Department id: id
    department.fetch
      success: ->
        new CPP.Views.Departments.Settings model: department
      error: ->
        notify "error", "Couldn't fetch department"