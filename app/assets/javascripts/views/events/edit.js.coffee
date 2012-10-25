class CPP.Views.EventsEdit extends CPP.Views.Base
  el: "#app"
  template: JST['events/edit']

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
    @model.save {},
      wait: true
      success: (model, company) ->
        console.log "sent"
        notify "success", "Event Saved"
      error: (model, company)->
        notify "error", "Event can not be saved"
        