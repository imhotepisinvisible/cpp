CPP.Views.Students ||= {}

class CPP.Views.Students.Admin extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/students/admin']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-save': 'save'
    'click .upload-document': 'uploadDocument'
    'click .delete-document': 'delDocument'
    'change #file-profile-picture': 'fileChange'

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

   profilePictureUploadInit: ->
    $('#file-profile-picture').fileupload
      singleFileUploads: true
      url: '/students/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploaddone", (e, data) =>
      window.history.back()
      notify 'success', 'Student saved'

    .bind "fileuploadfail", (e, data) =>
      displayJQZHRErrors data

  delDocument: ->
    $('#student-profile-img').attr('src', '/assets/default_profile.png')

  deleteDocument: (documentType) ->
    $.ajax
      url: "/students/#{@model.id}/documents/#{documentType}"
      type: 'DELETE'
      success: (data) ->
        window.history.back()
        notify 'success', 'Student saved'
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
        success: (model, response) =>
          if $('#file-profile-picture').get(0).files.length > 0
            @profilePictureUploadInit()
            $('#file-profile-picture').fileupload 'send',
              files: $('#file-profile-picture').get(0).files
          else if $('#student-profile-img').attr('src') == '/assets/default_profile.png'
            @deleteDocument 'profile_picture'
          else
            window.history.back()
            notify "success", "Student saved"
            @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          if response.errors
            window.displayErrorMessages response.errors
          else
            notify 'error', 'Unable to save student'
