class CPP.Views.CompaniesSettings extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/settings']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #delete-company' : 'deleteCompany'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(company: @model))

    new CPP.Views.Users.ChangePassword
      el: $(@el).find('#change-password')
      model: @model
    .render()

  deleteCompany: (e) ->
    if confirm "Are you sure you wish to delete your profile?\nThis cannot be undone."
      $.ajax
        url: "/companies/#{@model.id}"
        type: 'DELETE'
        success: (data) ->
          Backbone.history.navigate('/')
        error: (data) ->
          notify('error', "Couldn't delete your account!\nPlease contact administrator.")