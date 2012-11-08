class CPP.Views.StudentsEdit extends CPP.Views.Base
  el: "#app"
  template: JST['students/edit']

  events:
    'click #btn-upload-cv': 'uploadCV'

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
    
    # Prepare the file uploader
    $('#file-cv').fileupload
      url: '/students/' + @model.id + '/upload_cv'
      dataType: 'json'
      progressall: (e, data) ->
        # Update progress bar
        progress = parseInt(data.loaded / data.total * 100, 10)
        $('#upload-bar').width(progress + '%')

      done: (e, data) ->
        notify 'success', 'CV Uploaded Successfully'
        console.log data.result.cv_location

        # Add in the download link
        $('#cv-location').html(data.result.cv_location)
        $('#uploaded-cv').removeClass('hidden')

    # Upload the file!
    $('#file-cv').fileupload 'send',
      files: $('#file-cv').get(0).files
