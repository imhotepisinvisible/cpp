class CPP.Views.EmailsIndex extends CPP.Views.Base
  el: '#app'
  template: JST['emails/index']

  events:
    "click .btn-add"      : "addEmail"
    'click .company-logo-header' : 'viewCompany'

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    # bind to model destroy so backbone view updates on destroy
    @collection.bind 'destroy', @render, @
    @render()

  render: ->
    $(@el).html(@template(emails: @collection))

    @collection.each (email) =>
      email.company = new CPP.Models.Company id: email.get("company_id")
      email.company.fetch
        success: ->
          # Render the email if we can get its company
          view = new CPP.Views.EmailsItem model: email
          @$('#emails').append(view.render().el)
        error: ->
          notify "error", "Couldn't fetch company for email"
    @

  addEmail: ->
    Backbone.history.navigate("companies/" + @collection.company.id + "/emails/new", trigger: true)

  viewCompany: ->
    if @collection.company 
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
    
