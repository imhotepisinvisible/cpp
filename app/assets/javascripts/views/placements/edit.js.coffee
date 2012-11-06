class CPP.Views.PlacementsEdit extends CPP.Views.Base
  el: "#app"

  template: JST['placements/editval']

  events:
    'click .btn-submit': 'submitPlacement'

  initialize: ->
    @form = new Backbone.Form(model: @model).render()
    @render()

  render: ->
    $(@el).html(@template(placement: @model))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('.form').append(@form.el)
    @form.on "change", =>
      @form.validate()
  @

  submitPlacement: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Placement Saved"
          Backbone.history.navigate('companies/' + @model.get('company_id') + '/placements', trigger: true)
          @undelegatePlacements()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save placement, please resolve issues below."
