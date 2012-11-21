class CPP.Views.EventsEdit extends CPP.Views.Base
  el: "#app"

  template: JST['events/editval']

  events:
    'click .btn-submit': 'submitEvent'

  initialize: ->
    @model.set "requirementsEnabled", false
    @form = new Backbone.Form(model: @model).render()
    Backbone.Validation.bind @form;
    @render()

  render: ->
    $(@el).html(@template(event: @model))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('.form').append(@form.el)
    # Initial check for rendering requirementes box
    if ((@model.get "requirements") != (null || ""))
      @model.set "requirementsEnabled", true
      # Tick Checkbox
      $(".requirements-checkbox").children()[0].children[0].checked = true;
      @form.fields["requirements"].$el.slideDown()
    @form.on "change", =>
      @form.validate()
    @form.on "requirementsEnabled:change", =>
      @form.fields["requirements"].$el.slideToggle()
  @

  submitEvent: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Event Saved"
          Backbone.history.navigate('companies/' + @model.get('company_id') + '/events', trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save event, please resolve issues below."
