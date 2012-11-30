class CPP.Views.CompanyContact extends CPP.Views.Base
  tagName: "li"
  className: "contact-display-container"

  events: -> _.extend {}, CPP.Views.Base::events,

  template: JST['company_contacts/contact']

  initialize: (options) ->
    @render

  render: ->
    $(@el).html(@template())
    @