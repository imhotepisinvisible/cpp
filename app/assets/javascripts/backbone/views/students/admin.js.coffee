CPP.Views.Students ||= {}

class CPP.Views.Students.Admin extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/students/admin']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-save': 'save'
    'click .upload-doc': 'uploadDocument'
    'click #delete-profile-picture': 'delProfile'
    'click .delete-doc': 'delDocument'
    'change #file-profile-picture': 'fileChange'
    'change #file-cv': 'documentChange'
    'change #file-transcript': 'documentChange'
    'change #file-covering-letter': 'documentChange'

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
          options: ['Looking for an Industrial Placement',
                    'Looking for a Summer Placement',
                    {val: '', label: 'Not looking for anything'}]
    .render()
    @render()

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

  delProfile: ->
    $('#student-profile-img').attr('src', '/assets/default_profile.png')

  documentChange: (e) ->
    # This is called when the file for a document is changed
    id = $(e.currentTarget).attr('id')
    docType = id.substring(id.indexOf('-') + 1)

    $("#delete-#{docType}").attr('data-delete', '')
    $("#table-#{docType}").removeClass('missing-document')
    files = $("#file-#{docType}").get(0).files
    if files.length > 0
      $("#filename-#{docType}").html(files[0].name)

  delDocument: (e) ->
    id = $(e.currentTarget).attr('id')
    docType = id.substring(id.indexOf('-') + 1)

    $("#delete-#{docType}").attr('data-delete', 'delete')
    $("#table-#{docType}").addClass('missing-document')
    $("#filename-#{docType}").html('')

  deleteDocument: (documentType) ->
    documentType = documentType.replace("-","_")
    $.ajax
      url: "/students/#{@model.id}/documents/#{documentType}"
      type: 'DELETE'  
      error: (data) ->
        notify('error', "Unable to remove #{documentType}")

  uploadDocument: (e) ->
    $(e.currentTarget).closest('.upload-container').find('.file-input').click()

  fileChange: (e) ->
    # When the logo changes, change the image src to the contents
    # of the new logo locally (without uploading so that cancel will
    # not upload)
    logo = $('#file-profile-picture').get(0).files[0]
    reader = new FileReader
    reader.onload = (e) ->
      $('#student-profile-img').attr('src', e.target.result)
    reader.readAsDataURL(logo)

  render: ->
    $(@el).html(@template(student: @model, editable: true))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('.form').append(@form.el)
    @form.on "change", =>
      @form.validate()
    @

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
