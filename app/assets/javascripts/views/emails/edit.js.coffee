class CPP.Views.EmailsEdit extends CPP.Views.Base
  el: "#app"

  template: JST['emails/editval']

  events:
    'click .btn-submit': 'submitEmail'

  initialize: ->
    @form = new Backbone.Form(model: @model).render()
    @render()


  render: ->
    $(@el).html(@template(email: @model))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('.form').append(@form.el)
    @form.on "change", =>
      @form.validate()
    tiny_mce_init()
  @

  submitEmail: ->
    tiny_mce_save()
    if @form.validate() == null 
      @form.commit()
      @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Email Saved"
          Backbone.history.navigate('companies/' + @model.get('company_id') + '/emails', trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save email, please resolve issues below."
