class CPP.Router extends Backbone.Router
  routes:
      '' : 'index'
      '*default': 'index'

  # Navigate to appropriate dashboard depending on current user
  index: ->
    if isStudent()
      Backbone.history.navigate("/edit", trigger: true)
    else if isCompanyAdmin()
      Backbone.history.navigate("/company_dashboard", trigger: true)
    else if isDepartmentAdmin()
      Backbone.history.navigate("/department_dashboard", trigger: true)
    else
      view = new CPP.Views.Site.Index
