class CPP.Routers.Site extends Backbone.Router
  routes:
      '' : 'index'

  # The company index page that admins will see
  index: ->
    if isStudent()
      Backbone.history.navigate("/dashboard", trigger: true)
    else if isCompanyAdmin()
      Backbone.history.navigate("/company_dashboard", trigger: true)
    else if isDepartmentAdmin()
      Backbone.history.navigate("/department_dashboard", trigger: true)
    else
      view = new CPP.Views.Site.Index
