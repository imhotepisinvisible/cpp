CPP.Views.Company ||= {}

class CPP.Views.Company.Signup extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/signup_company']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submit'

  initialize: (options) ->
    @login = options.login
    @company = options.company
    @form = new Backbone.Form
      model: @model
    .render()
    @render()

  render: ->
    $(@el).html(@template(companyAdministrator: @model, company: @company))
    super
    $('.form').append(@form.el)
    Backbone.Validation.bind @form
    validateField(@form, field) for field of @form.fields
    @

  submit: (e) ->
    if @form.validate() == null
      @form.commit()
      deferreds = []
      # Save the new company with temporary name and desc
      email = @model.get 'email'
      @company.set 'name', email.substring(email.indexOf('@') + 1, email.lastIndexOf('.'))
      @company.set 'description', 'Please enter a company description'
      @company.set 'departments', @form.getValue().departments
      deferreds.push(
        @company.save {},
          wait: true
          forceUpdate: true
          success: (model, response) =>
            # Attach new admin to new company
            @model.set 'company_id', model.get 'id'
          error: (model, response) =>
            notify 'error', 'Could not create company')

      $.when.apply($, deferreds).done(=>
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
      )

  redirect: (model) ->
    go = ->
      window.location = '/#/companies/' + model.get('company_id') + '/edit'
      window.location.reload(true)

    if @login
      $.post '/sessions', { session: { email: model.get('email'), password: model.get('password') } }, go
    else
      go()