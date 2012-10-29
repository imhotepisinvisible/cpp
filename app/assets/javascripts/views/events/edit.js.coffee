class CPP.Views.EventsEdit extends CPP.Views.Base
  el: "#app"

  template: JST['events/editval']

  events:
    'click .btn-submit': 'submitEvent'

#  modelBindings:
#    "change form input#title"           : "title"
#    "change form input#start_date"      : "start_date"
#    "change form input#end_date"        : "end_date"
#    "change form input#deadline"        : "deadline"
#    "change form textarea#description"  : "description"
#    "change form input#location"        : "location"
#    "change form input#capacity"        : "capacity"
#    "change form input#google_map_url"  : "google_map_url"
#    "change form input#company_id"      : "company_id"

  initialize: ->
    @form = new Backbone.Form(model: @model).render()
    @render()

  render: ->
    $(@el).html(@template(event: @model))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('.form').append(@form.el)
    @form.on "change", ->
      console.log @model.get 'description'
      console.log @model.get "start_date"
      # commit the form
      @commit()
    # $('#c0_start_date').datepicker().on "changeDate", =>
    #   @model.set "start_date" ,"10/10/2020"
  @

  submitEvent: ->
    @form.commit()
    # $('.control-group').removeClass('error')
    # $('.help-inline').html('')
    if @form.validate() == null 
      @model.save {},
        wait: true
        success: (model, response) ->
          notify "success", "Event Saved"
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          console.log errorlist
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

         notify "error", "Unable to save event, please resolve issues below."
