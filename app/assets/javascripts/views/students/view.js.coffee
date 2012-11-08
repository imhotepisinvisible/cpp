class CPP.Views.StudentsView extends CPP.Views.Base
  el: "#app"
  template: JST['students/view']

  events:
    'click #btn-upload': 'uploadCV'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(student: @model))

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events

    placements_partial = new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements
    @

  uploadCV: ->
    console.log 'uploading...'
    # Prepare the file uploader
    $('#file-cv').fileupload
      url: 'cv.json'
      dataType: 'json'
      progressall: (e, data) ->
        # Update progress bar
        progress = parseInt(data.loaded / data.total * 100, 10)
        $('#upload-bar').width(progress + '%')

      done: (e, data) ->
        console.log 'successfully uploaded'

    # Upload the file!
    $('#file-cv').fileupload 'send',
      files: $('#file-cv').get(0).files