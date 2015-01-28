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

  # Save the company adminsitrator
  submit: (e) ->
    if @form.validate() == null
      @form.commit()
      @model.set 'company_id', @company.get 'id'
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Registered"
          @redirect(model)
          
        error: (model, response) =>
          if response.responseText
            errorlist = JSON.parse response.responseText
            for field, errors of errorlist.errors
              if field of @form.fields
                @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to register, please resolve issues below."
      
  # Redirect to company edit page
  redirect: (model) ->
    window.location = '/companies/' + model.get('company_id') + '/edit'
    window.location.reload(true)