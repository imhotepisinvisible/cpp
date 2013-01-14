class CPP.Views.CompaniesSettings extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/settings']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #delete-company' : 'deleteCompany'

  # Company settings page
  initialize: ->
    @render()

  # Render company settings page
  render: ->
    $(@el).html(@template(company: @model, tooltip: (loggedIn() and CPP.CurrentUser.get('tooltip'))))

    # Change password partial
    new CPP.Views.Users.ChangePassword
      el: $(@el).find('#change-password')
    .render()

    # Set up tooltip switch
    $('#tooltip-switch').toggleButtons(
      onChange: (el, status, e) =>
        stateText = if status then 'on' else 'off'
        CPP.CurrentUser.set 'tooltip', status
        CPP.CurrentUser.save {},
          wait: true
          forceUpdate: true
          success: (model, response) =>
            notify 'success', "Switched #{stateText} helpful tooltips"
          error: (model, response) =>
            notify 'error', "Unable to switch #{stateText} helpful tooltips"
    )

  # Delete the company
  deleteCompany: (e) ->
    if confirm "Are you sure you wish to delete your profile?\nThis cannot be undone."
      $.ajax
        url: "/companies/#{@model.id}"
        type: 'DELETE'
        success: (data) ->
          Backbone.history.navigate('/')
        error: (data) ->
          notify('error', "Couldn't delete your account!\nPlease contact administrator.")