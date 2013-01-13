CPP.Views.Departments ||= {}

class CPP.Views.Departments.Approvals extends CPP.Views.Base
  template: JST['backbone/templates/departments/approvals']

  # Initializes department approval
  # Fetches department pending companies and email requests
  initialize: (options) ->
    _.bindAll @, 'render'
    @model.pending_companies.fetch
      success: =>
        @companyCollection = @model.pending_companies
        @companyCollection.bind 'remove', @render, @
        @companyCollection.bind 'change', @render, @
        @model.pending_emails.fetch
          success: =>
            @emailCollection = @model.pending_emails
            @emailCollection.bind 'remove', @render, @
            @emailCollection.bind 'change', @render, @
            @render()
          error: =>
            notify 'error', 'Could not fetch email requests'
      error: ->
        notify 'error', 'Could not fetch company approval requests'

  # Renders template
  # Display company approval partial and pending email partial for each
  # item in the collections
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
