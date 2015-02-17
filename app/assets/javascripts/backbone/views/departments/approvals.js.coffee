CPP.Views.Departments ||= {}

class CPP.Views.Departments.Approvals extends CPP.Views.Base
  template: JST['backbone/templates/departments/approvals']

  # Initializes department approval
  # Fetches department pending companies and email requests
  initialize: (options) ->
    _.bindAll @, 'render'
    @companyCollection = @model.pending_companies
    @companyCollection.bind 'reset', @renderPendingCompanies, @
    @companyCollection.bind 'remove', @renderPendingCompanies, @
    @companyCollection.bind 'change', @renderPendingCompanies, @
    @companyCollection.fetch
      error: ->
        notify 'error', 'Could not fetch company approval requests'
    @emailCollection = @model.pending_emails
    @emailCollection.bind 'reset', @renderPendingEmails, @
    @emailCollection.bind 'remove', @renderPendingEmails, @
    @emailCollection.bind 'change', @renderPendingEmails, @
    @emailCollection.fetch
      error: =>
        notify 'error', 'Could not fetch email requests'
    @eventCollection = @model.pending_events
    @eventCollection.bind 'reset', @renderPendingEvents, @
    @eventCollection.bind 'remove', @renderPendingEvents, @
    @eventCollection.bind 'change', @renderPendingEvents, @
    @eventCollection.fetch
        error: =>
          notify 'error', 'Could not fetch event requests'
    @placementCollection = @model.pending_placements
    @placementCollection.bind 'reset', @renderPendingPlacements, @
    @placementCollection.bind 'remove', @renderPendingPlacements, @
    @placementCollection.bind 'change', @renderPendingPlacements, @
    @placementCollection.fetch
        error: =>
          notify 'error', 'Could not fetch opportunity requests'
    @render()


  # Renders template
  render: ->
    $(@el).html(@template(dept: @model))
    @renderPendingCompanies
    @renderPendingEmails
    @renderPendingEvents
    @renderPendingPlacements
  
  # Display pending company partial for each item in the collection
  renderPendingCompanies: ->
    @$('#company-count').html("")
    @$('#company-approvals').html ""
    if @companyCollection.length > 0
      @$('#company-count').html(@companyCollection.length)
      @companyCollection.each (company) =>
        view = new CPP.Views.Departments.CompanyApproval
          model: company
          dept: @model
        @$('#company-approvals').append(view.render().el)
    else
      @$('#company-approvals').append "<li>No pending company requests</li>"

  # Display pending email partial for each item in the collection
  renderPendingEmails: ->
    @$('#email-count').html("")
    @$('#email-approvals').html ""
    if @emailCollection.length > 0
      @$('#email-count').html(@emailCollection.length)
      @emailCollection.each (email) =>
        view = new CPP.Views.Departments.EmailApproval
          model: email
          dept: @model
        @$('#email-approvals').append(view.render().el)
    else
      @$('#email-approvals').append "<li>No pending email requests</li>"

  # Display pending event partial for each item in the collection
  renderPendingEvents: ->
    @$('#event-count').html("")
    @$('#event-approvals').html ""
    if @eventCollection.length > 0
      @$('#event-count').html(@eventCollection.length)
      @eventCollection.each (event) =>
        view = new CPP.Views.Departments.EventApproval
          model: event
          dept: @model
        @$('#event-approvals').append(view.render().el)
    else
      @$('#event-approvals').append "<li>No pending event requests</li>"

  # Display pending placement partial for each item in the collection
  renderPendingPlacements: ->
    @$('#placement-count').html("")
    @$('#placement-approvals').html ""
    if @placementCollection.length > 0
      @$('#placement-count').html(@placementCollection.length)
      @placementCollection.each (placement) =>
        view = new CPP.Views.Departments.PlacementApproval
          model: placement
          dept: @model
        @$('#placement-approvals').append(view.render().el)
    else
      @$('#placement-approvals').append "<li>No pending opportunity requests</li>"
