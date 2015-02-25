class CPP.Routers.Companies extends Backbone.Router
  routes:
      'companies'             : 'index'
      'companies/new'         : 'new'
      'companies/register'    : 'signup'
      'companies/:id/register': 'signupCompany'
      'companies/:id'         : 'view'
      'companies/:id/edit'    : 'edit'
      'companies/:id/settings': 'settings'
      'company_dashboard'     : 'edit'

  # The company index page that admins will see
  index: ->
    companies = new CPP.Collections.Companies
    if isStudent()
        view = new CPP.Views.CompaniesStudentIndex collection: companies
    else
        view = new CPP.Views.CompaniesIndex collection: companies
    companies.fetch
      success: ->
        if isStudent() # why ComapaniesIndex not Companies.index
          view = new CPP.Views.CompaniesStudentIndex collection: companies
        else
          view = new CPP.Views.CompaniesIndex collection: companies
      error: ->
        notify "error", "Couldn't fetch companies"

  # The company profile page that students will see
  view: (id) ->
    company = new CPP.Models.Company id: id

    # Wait for all of these before fetching company
    deferreds = []
    deferreds.push(company.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.placements.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.departments.fetch())

    if isAdmin()
      deferreds.push(company.emails.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(=>
      @setCompany company.events.models, company
      @setCompany company.placements.models, company

      company.fetch
        success: ->
          new CPP.Views.CompaniesView model: company
        error: ->
          notify "error", "Couldn't fetch company"
    )

  # Administrate a company
  admin: (id) ->
    company = new CPP.Models.Company id: id
    company.fetch
      success: ->
        new CPP.Views.Companies.Admin model: company
      error: ->
        notify 'error', "Couldn't fetch company"

  # Set the company property of a collection of models
  setCompany: (models, company) ->
    for model in models
      do (model) ->
        model.company = company

  # Company dashboard
  edit: (id) ->
    if isDepartmentAdmin()
      # Redirect administrator to admin page
      @admin(id)
      return

    if isStudent()
      # Redirect student away
      window.history.back()
      return false

    if !id? && isCompanyAdmin()
      id = CPP.CurrentUser.get('company_id')

    company = new CPP.Models.Company id: id

    # Wait for all of these before fetching company
    deferreds = []
    deferreds.push(company.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.placements.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.emails.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(=>
      @setCompany company.events.models, company
      @setCompany company.placements.models, company

      company.fetch
        success: ->
          new CPP.Views.CompaniesEdit model: company
        error: ->
          notify "error", "Couldn't fetch company"
    )


  # Page to create a new company by an admin
  new: ->
    if isStudent()
      window.history.back()
      return false

    department_id = CPP.CurrentUser.get('department_id')
    company = new CPP.Models.Company departments: [department_id]
    company.collection = new CPP.Collections.Companies
    new CPP.Views.Companies.Admin model: company

  # Sign up a company administrator for an existing company
  signupCompany: (id) ->
    if CPP.CurrentUser? and
      (CPP.CurrentUser.get('type') == 'DepartmentAdministrator' or
       CPP.CurrentUser.get('type') == 'CompanyAdministrator')
      company = new CPP.Models.Company id: id
      company.fetch
        success: ->
          companyAdmin = new CPP.Models.CompanyAdministrator
          new CPP.Views.CompanyAdministrator.Signup
            model: companyAdmin
            company: company
        error: ->
          notify 'error', "Couldn't fetch company"
    else
      window.history.back()
      return false

  # Signup a new company
  signup: ->
    if CPP.CurrentUser? && CPP.CurrentUser.get('type') == 'DepartmentAdministrator'
      # Dept administrator registering new admin and company
      # so don't log in once registered
      @signupNewCompany false
    else
      window.history.back()
      return false

  # Signup a new company
  signupNewCompany: (login) ->
    if login && CPP.CurrentUser? && CPP.CurrentUser isnt {}
      window.history.back()
      return false
    companyAdmin = new CPP.Models.CompanyAdministrator
    new CPP.Views.Company.Signup
      model: companyAdmin
      login: login
      company: new CPP.Models.Company

  # Company settings page
  settings: (id) ->
    if isStudent()
      window.history.back()
      return false

    company = new CPP.Models.Company id: id

    # Wait for all of these before fetching company
    deferreds = []
    deferreds.push(company.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.placements.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.emails.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(->
      company.fetch
        success: ->
          new CPP.Views.CompaniesSettings model: company
        error: ->
          notify "error", "Couldn't fetch company"
    )
