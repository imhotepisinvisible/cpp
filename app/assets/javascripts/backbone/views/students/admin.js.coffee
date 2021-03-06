CPP.Views.Students ||= {}

# Admin view of student
class CPP.Views.Students.Admin extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/students/admin']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-save': 'save'
    'click .upload-doc': 'uploadDocument'
    'click #delete-profile-picture': 'delProfile'
    'click .delete-doc': 'delDocument'
    'change #file-profile-picture': 'fileChange'
    'change #file-cv': 'documentChange'
    'change #file-transcript': 'documentChange'
    'change #file-covering-letter': 'documentChange'

  # If user is not a department admin then redirect
  # Initialise the student administrator form
  initialize: ->
    if !(isDepartmentAdmin())
      Backbone.history.navigate("/", trigger: true)
      return
    @form = new Backbone.Form
      model: @model
      schema:
        first_name:
          title: 'First Name'
          type: 'Text'
        last_name:
          title: 'Last Name'
          type: 'Text'
        year:
          title: 'Year'
          type: 'Number'
        degree:
          title: 'Degree'
          type: 'Text'
        bio:
          title: 'About Me'
          type: 'TextArea'
        looking_for:
          title: 'Looking for'
          type: 'Select'
          options: [ looking_fors.industrial,
                     looking_fors.summer,
                     looking_fors.graduate,
                    {val: '', label: looking_fors.nothing}]
    .render()
    @render()

  # Upload a document
  uploadInitialize: (documentType) ->
    $('#file-' + documentType).fileupload
      url: '/students/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploaddone", (e, data) =>
      upload = $(e.target).closest('.upload-container')
      upload.find('.progress-upload').delay(250).slideUp 'slow', ->
        upload.find('.bar').width('0%')
        upload.removeClass('missing-document')

    .bind "fileuploadstart", (e, data) ->
      $(e.currentTarget).closest('.upload-container').find('.progress-upload').slideDown()

    .bind "fileuploadprogress", (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $("#progress-#{documentType}").width(progress + '%')

    .bind "fileuploadfail", (e, data) =>
      upload = $(e.target).closest('.upload-container')
      upload.find('.progress-upload').delay(250).slideUp 'slow', ->
        upload.find('.bar').width('0%')
      displayJQXHRErrors data

  # Delete profile image
  delProfile: ->
    $('#student-profile-img').attr('src', '/assets/default_profile.png')

  # Update document view when the file for a document is changed
  documentChange: (e) ->
    id = $(e.currentTarget).attr('id')
    docType = id.substring(id.indexOf('-') + 1)

    $("#delete-#{docType}").attr('data-delete', '')
    $("#table-#{docType}").removeClass('missing-document')
    files = $("#file-#{docType}").get(0).files
    if files.length > 0
      $("#filename-#{docType}").html(files[0].name)

  # Update document view on deletion
  delDocument: (e) ->
    id = $(e.currentTarget).attr('id')
    docType = id.substring(id.indexOf('-') + 1)

    $("#delete-#{docType}").attr('data-delete', 'delete')
    $("#table-#{docType}").addClass('missing-document')
    $("#filename-#{docType}").html('')

  # Delete a document
  deleteDocument: (documentType) ->
    documentType = documentType.replace("-","_")
    $.ajax
      url: "/students/#{@model.id}/documents/#{documentType}"
      type: 'DELETE'
      error: (data) ->
        notify('error', "Unable to remove #{documentType}")

  # Update document view on upload
  uploadDocument: (e) ->
    $(e.currentTarget).closest('.upload-container').find('.file-input').click()

  # When the logo changes, change the image src to the contents
  # of the new logo locally (without uploading so that cancel will
  # not upload)
  fileChange: (e) ->
    logo = $('#file-profile-picture').get(0).files[0]
    reader = new FileReader
    reader.onload = (e) ->
      $('#student-profile-img').attr('src', e.target.result)
    reader.readAsDataURL(logo)

  # Render admin student view and validate individual fields
  render: ->
    $(@el).html(@template(student: @model, editable: true))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('#main-form').append(@form.el)
    validateField(@form, field) for field of @form.fields
    @

  # Save the student profile 
  save: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          # Upload the files that have changed
          deferreds = []
          for docType in ['profile-picture', 'cv', 'transcript', 'covering-letter']
            if $("#delete-#{docType}").attr('data-delete') == 'delete'
              deferreds.push(@deleteDocument docType)
            else if $("#file-#{docType}").get(0).files.length > 0
              @uploadInitialize docType
              deferreds.push(
                $("#file-#{docType}").fileupload 'send',
                  files: $("#file-#{docType}").get(0).files)

          # Delete profile picture if necessary
          if $('#student-profile-img').attr('src') == '/assets/default_profile.png'
            deferreds.push(@deleteDocument 'profile-picture')

          # When everything has been uploaded/deleted as required,
          # navigate away and notify success
          $.when.apply($, deferreds).done(=>
            Backbone.history.navigate("/students/#{@model.id}", trigger: true)
            notify 'success', 'Student saved'
            @undelegateEvents()
          )

        error: (model, response) =>
          try
            errorlist = JSON.parse response.responseText
            if response.errors
              window.displayErrorMessages response.errors
            else
              notify 'error', 'Unable to save student'
          catch err
            notify 'error', response.responseText
