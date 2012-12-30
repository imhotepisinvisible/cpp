class CPP.Routers.Companies extends Backbone.Router
  routes:
      'companies': 'index'
      'companies/:id': 'view'
      'companies/:id/edit': 'edit'
      'companies/:id/settings': 'settings'

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
    deferreds.push(company.tagged_emails.fetch({ data: $.param({ limit: 3}) }))

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

    company = new CPP.Models.Company id: id

    # Wait for all of these before fetching company
    deferreds = []
    deferreds.push(company.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.placements.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.tagged_emails.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(=>
      @setCompany company.events.models, company
      @setCompany company.placements.models, company

      company.fetch
        success: ->
          new CPP.Views.CompaniesEdit model: company
        error: ->
          notify "error", "Couldn't fetch company"
    )

  settings: (id) ->
    company = new CPP.Models.Company id: id

    # Wait for all of these before fetching company
    deferreds = []
    deferreds.push(company.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.placements.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.tagged_emails.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(->
      company.fetch
        success: ->
          new CPP.Views.CompaniesSettings model: company
        error: ->
          notify "error", "Couldn't fetch company"
    )
