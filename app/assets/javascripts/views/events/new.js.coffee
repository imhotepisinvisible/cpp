class CPP.Views.EventsNew extends CPP.Views.Base
  el: "#app"
  template: JST['events/new']

  modelBindings:
    "change form input#title"           : "title"
    "change form input#start_date"      : "start_date"
    "change form input#end_date"        : "end_date"
    "change form input#deadline"        : "deadline"
    "change form textarea#description"  : "description"
    "change form input#location"        : "location"
    "change form input#capacity"        : "capacity"
    "change form input#google_map_url"  : "google_map_url"
    "change form input#company_id"      : "company_id"

  events:
    'click .btn-submit': 'submitEvent'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(event: @model))
    super
    @

  submitEvent: ->
    console.log @model.get("title")
    @model.save
      wait: true
      success: ->
        notify "success", "model saved"
      error: ->
        notify "error", "broken"