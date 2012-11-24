class CPP.Routers.Companies extends Backbone.Router
  routes:
      'companies': 'index'
      'companies_student': 'studentIndex'
      'companies/:id': 'view'
      'companies/:id/edit': 'edit'

  # The company index page that admins will see
  index: ->
    companies = new CPP.Collections.Companies
    companies.fetch
      success: ->
        new CPP.Views.CompaniesIndex collection: companies
      error: ->
        notify "error", "Couldn't fetch companies"

  # The company index page that students will see
  studentIndex: ->
    companies = new CPP.Collections.Companies
    companies.fetch
      success: ->
        new CPP.Views.CompaniesStudentIndex collection: companies
      error: ->
        notify "error", "Couldn't fetch companies"

  view: (id) ->
    company = new CPP.Models.Company id: id

    company.events.fetch({ data: $.param({ limit: 3}) })
    company.placements.fetch({ data: $.param({ limit: 3}) })
    company.emails.fetch({ data: $.param({ limit: 3}) })
    company.company_contacts.fetch({ data: $.param({ limit: 3}) })

    company.fetch
      success: ->
        new CPP.Views.CompaniesView model: company
      error: ->
        notify "error", "Couldn't fetch company"

  edit: (id) ->
    company = new CPP.Models.Company id: id

    company.events.fetch({ data: $.param({ limit: 3}) })
    company.placements.fetch({ data: $.param({ limit: 3}) })
    company.emails.fetch({ data: $.param({ limit: 3}) })

    company.fetch
      success: ->
        new CPP.Views.CompaniesEdit model: company
      error: ->
        notify "error", "Couldn't fetch company"
