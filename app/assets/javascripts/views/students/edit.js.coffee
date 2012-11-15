class CPP.Views.StudentsEdit extends CPP.Views.Base
  el: "#app"
  template: JST['students/edit']

  events:
    'click .upload-document': 'uploadDocument'
    'click .delete-document': 'deleteDocument'
    'click #bio-container': 'bioEdit'
    'blur #bio-textarea-container': 'bioStopEdit'
    'click #name-container': 'nameEdit'
    'blur #name-textarea-container': 'nameStopEdit'
    'click #year-container': 'yearEdit'
    'blur #year-textarea-container': 'yearStopEdit'
    'click #degree-container': 'degreeEdit'
    'blur #degree-textarea-container': 'degreeStopEdit'

  initialize: ->
    @render()
    @checkAllDocuments()

  render: ->
    super
    $(@el).html(@template(student: @model))

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events

    placements_partial = new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements

    @uploadInitialize 'cv'
    @uploadInitialize 'transcript'
    @uploadInitialize 'coveringletter'

    @

  uploadInitialize: (documentType) ->
    # Prepare the file uploader
    $('#file-' + documentType).fileupload
      url: '/students/' + @model.id + '/upload_document/' + documentType
      dataType: 'json'
      #fileInput: null # do not bind to change event
      progressall: (e, data) ->
        # Update progress bar
        progress = parseInt(data.loaded / data.total * 100, 10)
        $('#progress-' + documentType).width(progress + '%')
        false

      done: (e, data) =>
        notify 'success', 'Uploaded successfully'
        @model.set 'cv_location', data.result.cv_location
        @model.set 'transcript_location', data.result.transcript_location
        @model.set 'coveringletter_location', data.result.coveringletter_location
        # Three parents up is td
        $(e.target).parent().parent().parent().find('.progress-upload').delay(1000).slideUp('slow', (->
          $(this).find('.bar').width('0%')))

        @checkAllDocuments()
        #$('#cv-location').html(data.result.cv_location)
        #$('#uploaded-cv').removeClass('hidden')
        false
    .bind "fileuploadstart", (e, data) ->
      $(e.currentTarget).parent().parent().parent().find('.progress-upload').slideDown()

  uploadDocument: (e) ->
    $(e.currentTarget).parent().parent().find('.file-input').click()

  deleteDocument: (e) ->
    id = $(e.currentTarget).attr('id')
    documentType = id.substring(id.lastIndexOf('-') + 1)

    if confirm('Are you sure you wish to delete your ' + documentType + '?')
      $.get('/students/' + @model.id + '/delete_document/' + documentType, (data) =>
        @model.set('cv_location', data.cv_location)
        @model.set('transcript_location', data.transcript_location)
        @model.set('coveringletter_location', data.coveringletter_location)
        @checkAllDocuments()
        )

  bioEdit: ->
    @edit 'bio'

  bioStopEdit: ->
    @stopEdit 'bio', 'string', ((bio) ->
      if bio then bio.replace(/\n/g, "<br/>") else 'Click here to edit your bio!')

  yearEdit: ->
    @edit 'year'

  yearStopEdit: ->
    @stopEdit 'year', 'int', getOrdinal

  degreeEdit: ->
    @edit 'degree'

  degreeStopEdit: ->
    @stopEdit 'degree', 'string', _.identity

  # displayFunction must take one argument - the value in the model and
  # must output a string to display in the edit window
  stopEdit: (attribute, type, displayFunction) ->
    value = $('#student-' + attribute + '-editor').val()
    value = if type == 'int' then parseInt(value) else value
    $('#' + attribute + '-textarea-container').hide()

    if value != @model.get attribute
      @model.set attribute, value
      @model.save {},
          wait: true
          success: (model, response) =>
            notify "success", "Updated profile"
            $('#student-' + attribute + '').html displayFunction(model.get(attribute))
            @model.set attribute, model.get(attribute)
            $('#' + attribute + '-container').show()
          error: (model, response) ->
            notify "error", "Failed to update profile"
    else
      $('#' + attribute + '-container').show()

  edit: (attribute) ->
    $('#' + attribute + '-container').hide()
    $('#student-' + attribute + '-editor').html(@model.get attribute)
    $('#' + attribute + '-textarea-container').show()
    $('#student-' + attribute + '-editor').focus()

  nameEdit: ->
    $('#name-container').hide()
    $('#student-name-editor').html(@model.get('first_name') + ' ' + @model.get('last_name'))
    $('#name-textarea-container').show()
    $('#student-name-editor').focus()

  nameStopEdit: ->
    name = $('#student-name-editor').val()
    lastName = name.substring(name.indexOf(' ') + 1)
    firstName = name.substring(0, name.indexOf(' '))
    $('#name-textarea-container').hide()

    if not ((firstName == @model.get 'first_name') and (lastName == @model.get 'last_name'))
      @model.set 'first_name', firstName
      @model.set 'last_name', lastName
      @model.save {},
          wait: true
          success: (model, response) =>
            notify "success", "Updated profile"
            $('#student-profile-intro-name').html(model.get('first_name') + ' ' + model.get('last_name'))
            @model.set 'first_name', model.get('first_name')
            @model.set 'last_name', model.get('last_name')
            $('#name-container').show()
          error: (model, response) ->
            notify "error", "Failed to update profile"
    else
      $('#name-container').show()

  checkAllDocuments: ->
    @checkDocument 'cv'
    @checkDocument 'transcript'
    @checkDocument 'coveringletter'

  checkDocument: (documentType) ->
    if @model.get "#{documentType}_location"
      $('#table-' + documentType).removeClass('missing-document')
      $('#download-' + documentType).show()
      $('#delete-' + documentType).show()
    else
      $('#table-' + documentType).addClass('missing-document')
      $('#download-' + documentType).hide()
      $('#delete-' + documentType).hide()
