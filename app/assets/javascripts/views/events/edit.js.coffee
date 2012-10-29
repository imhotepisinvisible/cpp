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
      @commit() 
  @

  submitEvent: ->
    @form.commit()
    $('.control-group').removeClass('error')
    $('.help-inline').html('')
    @model.save {},
      wait: true
      success: (model, response) ->
        notify "success", "Event Saved"
      error: (model, response)->
        errors = JSON.parse response.responseText
        errorText = "<h5>Event cannot be saved, please fix the following errors:</h5>"
        for field, error of errors
          $('#' + field).parent().parent().addClass('error')
          $('#' + field).parent().append("<span class=\"help-inline\">#{error}</span>")
          errorText += "<li>#{field} - #{error}</li>"
        notify "error", errorText
        
