CPP.Views.Companies ||= {}

class CPP.Views.Companies.Admin extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/companies/admin']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-save': 'save'
    'click .upload-document': 'uploadDocument'
    'click .delete-document': 'delDocument'
    'change #file-logo': 'fileChange'

  initialize: ->
    @form = new Backbone.Form
      model: @model
      schema:
        name:
          title: 'Name'
          type: 'Text'
        description:
          title: 'Description'
          type: 'TextArea'
    .render()
    @render()
    $.get "/companies/#{@model.id}/departments/#{getAdminDepartment()}/status", (status) ->
      $('#select-approval-status').val(status)

  logoUploadInitialize: ->
    $('#file-logo').fileupload
      singleFileUploads: true
      url: '/companies/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploaddone", (e, data) =>
      Backbone.history.navigate('/companies/' + @model.id, trigger: true)
      notify 'success', 'Company saved'

    .bind "fileuploadstart", (e, data) ->
      $(e.currentTarget).closest('.upload-container').find('.progress-upload').slideDown()

    .bind "fileuploadprogress", (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('#progress-logo').width(progress + '%')

    .bind "fileuploadfail", (e, data) =>
      upload = $(e.target).closest('.upload-container')
      upload.find('.progress-upload').delay(250).slideUp 'slow', ->
        upload.find('.bar').width('0%')
      displayJQZHRErrors data

  delDocument: ->
    $('.company-logo-image').attr('src', '/assets/default_profile.png')

  deleteDocument: ->
    $.ajax
      url: "/companies/#{@model.id}/logo"
      type: 'DELETE'
      success: (data) =>
        Backbone.history.navigate('/companies/' + @model.id, trigger: true)
        notify 'success', 'Company saved'
      error: (data) ->
        notify('error', "Unable to remove logo")

  uploadDocument: (e) ->
    $(e.currentTarget).closest('.upload-container').find('.file-input').click()

  render: ->
    $(@el).html(@template(company: @model))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('.form').append(@form.el)
    Backbone.Validation.bind @form
    
    validateField(@form, field) for field of @form.fields

    new CPP.Views.Companies.EditAdministrators
      el: $(@el).find('#edit-admins')
      company: @model
      header: false
    @

  fileChange: (e) ->
    # When the logo changes, change the image src to the contents
    # of the new logo locally (without uploading so that cancel will
    # not upload)
    logo = $('#file-logo').get(0).files[0]
    reader = new FileReader
    reader.onload = (e) ->
      $('.company-logo-image').attr('src', e.target.result)
    reader.readAsDataURL(logo)

  save: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          $.ajax
            url: "/companies/#{@model.id}/departments/#{getAdminDepartment()}/status"
            type: 'PUT'
            data:
              status: $('#select-approval-status').val()
            success: =>
              if $('#file-logo').get(0).files.length > 0
                @logoUploadInitialize()
                $('#file-logo').fileupload 'send',
                  files: $('#file-logo').get(0).files
              else if $('.company-logo-image').attr('src') == '/assets/default_profile.png'
                @deleteDocument()
              else
                Backbone.history.navigate('/companies/' + @model.id, trigger: true)
                notify "success", "Company saved"
                @undelegateEvents()
            error: =>
              notify 'error', "Could not change approval status"
        error: (model, response) =>
          try
            errorlist = JSON.parse response.responseText
            if response.errors
              window.displayErrorMessages response.errors
            else
              notify 'error', 'Unable to save company'
          catch err
            notify 'error', response.responseText