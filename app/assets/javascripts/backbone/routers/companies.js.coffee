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
    companies.fetch
      success: ->
        if isStudent()
          view = new CPP.Views.CompaniesStudentIndex collection: companies
        else
          view = new CPP.Views.CompaniesIndex collection: companies
      error: ->
        notify "error", "Couldn't fetch companies"

  view: (id) ->
    company = new CPP.Models.Company id: id

    # Wait for all of these before fetching company
    deferreds = []
    deferreds.push(company.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.placements.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.emails.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.departments.fetch())

    $.when.apply($, deferreds).done(=>

      @setCompany company.events.models, company
      @setCompany company.placements.models, company

      company.fetch
        success: ->
          new CPP.Views.CompaniesView model: company
        error: ->
          notify "error", "Couldn't fetch company"
    )

  admin: (id) ->
    if id?
      company = new CPP.Models.Company id: id
    company = new CPP.Models.Company id: id
    company.fetch
      success: ->
        new CPP.Views.Companies.Admin model: company
      error: ->
        notify 'error', "Couldn't fetch company"

  setCompany: (models, company) ->
    for model in models
      do (model) ->
        model.company = company

  edit: (id) ->
    if isDepartmentAdmin()
      @admin(id)
      return

    if isStudent()
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


  new: ->
    if isStudent()
      window.history.back()
      return false

    department_id = CPP.CurrentUser.get('department_id')
    company = new CPP.Models.Company departments: [department_id]
    company.collection = new CPP.Collections.Companies
    new CPP.Views.Companies.Admin model: company

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

  signup: ->
    if CPP.CurrentUser? && CPP.CurrentUser.get('type') == 'DepartmentAdministrator'
      # Dept administrator registering new admin and company
      # so don't log in once registered
      @signupNewCompany false
    else if not CPP.CurrentUser?
      # Nobody logged in, registering new company admin and new company
      @signupNewCompany true
    else
      window.history.back()
      return false

  signupNewCompany: (login) ->
    if login && CPP.CurrentUser? && CPP.CurrentUser isnt {}
      window.history.back()
      return false
    companyAdmin = new CPP.Models.CompanyAdministrator
    new CPP.Views.Company.Signup
      model: companyAdmin
      login: login
      company: new CPP.Models.Company

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
