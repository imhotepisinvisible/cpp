CPP.Views.Departments ||= {}

class CPP.Views.Departments.Approvals extends CPP.Views.Base
  template: JST['backbone/templates/departments/approvals']

  initialize: (options) ->
    @model.pending_companies.fetch
      success: =>
        @companyCollection = @model.pending_companies
        @model.pending_emails.fetch
          success: =>
            @emailCollection = @model.pending_emails
            @render()
          error: =>
            notify 'error', 'Could not fetch email requests'
      error: ->
        notify 'error', 'Could not fetch company approval requests'

  render: ->
    $(@el).html(@template(dept: @model))
    if @companyCollection.length > 0
      @companyCollection.each (company) =>
        view = new CPP.Views.Departments.CompanyApproval
          model: company
          dept: @model
        @$('#company-approvals').append(view.render().el)
    else
      @$('#company-approvals').append "No pending company requests!"

    if @emailCollection.length > 0
      @emailCollection.each (email) =>
        view = new CPP.Views.Departments.EmailApproval
          model: email
          dept: @model
        @$('#email-approvals').append(view.render().el)
    else
      @$('#email-approvals').append "No pending email requests!"
