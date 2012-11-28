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
        new CPP.Views.CompaniesIndex collection: companies
      error: ->
        notify "error", "Couldn't fetch companies"

  view: (id) ->
    company = new CPP.Models.Company id: id

    # Wait for all of these before fetching company
    deferreds = []
    deferreds.push(company.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.placements.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.emails.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(->
      company.fetch
        success: ->
          new CPP.Views.CompaniesView model: company
        error: ->
          notify "error", "Couldn't fetch company"
    )

  edit: (id) ->
    company = new CPP.Models.Company id: id

    # Wait for all of these before fetching company
    deferreds = []
    deferreds.push(company.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.placements.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(company.emails.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(->
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
    deferreds.push(company.emails.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(->
      company.fetch
        success: ->
          new CPP.Views.CompaniesSettings model: company
        error: ->
          notify "error", "Couldn't fetch company"
    )