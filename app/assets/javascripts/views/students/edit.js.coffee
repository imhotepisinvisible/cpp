class CPP.Views.StudentsEdit extends CPP.Views.Base
  el: "#app"
  template: JST['students/edit']

  events:
    'click .upload-document': 'uploadDocument'

  initialize: ->
    @render()
    @uploadInitialize 'cv'
    @uploadInitialize 'transcript'
    @uploadInitialize 'coveringletter'

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

  uploadInitialize: (documentType) ->
    # Prepare the file uploader
    $('#file-' + documentType).fileupload
      url: '/students/' + @model.id + '/upload_' + documentType
      dataType: 'json'
      #fileInput: null # do not bind to change event
      progressall: (e, data) ->
        # Update progress bar
        progress = parseInt(data.loaded / data.total * 100, 10)
        $('#progress-' + documentType).width(progress + '%')
        false

      done: (e, data) ->
        console.log data
        notify 'success', 'Uploaded Successfully'
        # Three parents up is td
        $(e.target).parent().parent().parent().find('.progress-upload').delay(1000).slideUp('slow', (->
          $(this).find('.bar').width('0%')))

        #$('#cv-location').html(data.result.cv_location)
        #$('#uploaded-cv').removeClass('hidden')
        false

  uploadDocument: (e) ->
    $(e.currentTarget).parent().parent().parent().find('.progress-upload').slideDown()
    $(e.currentTarget).parent().parent().find('.file-input').click()