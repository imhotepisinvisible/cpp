CPP.Views.CompanyAdministrator ||= {}

class CPP.Views.CompanyAdministrator.Signup extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/signup']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submit'

  # Company administrator signup page
  initialize: (options) ->
    @company = options.company
    @form = new Backbone.Form
      model: @model
    .render()
    @render()

  # Render company administrator signup page
  render: ->
    $(@el).html(@template(companyAdministrator: @model, company: @company))
    super
    $('.form').append(@form.el)
    Backbone.Validation.bind @form
    validateField(@form, field) for field of @form.fields
    @

  # Save the company administrator
  submit: (e) ->
    if @form.validate() == null
      data = {}
      data['user'] = @form.getValue()
      data['user[type]'] = 'CompanyAdministrator'
      data['user[company_id]'] = @company.get 'id'
      $.ajax
        url: "/users.json"
        data: data
        type: 'POST'
        success: (data) =>
          notify "success", "Registered", 2000
          setTimeout(
            -> Backbone.history.navigate("companies/" + _this.company.get('id') + "/edit", trigger: true)
          , 2500)
        error: (data) =>
          if data.responseText
            errorlist = JSON.parse data.responseText
            for field, errors of errorlist.errors
              if field of @form.fields
                @form.fields[field].setError(errors.join ', ')
          notify "error", "Unable to register, please resolve issues below."