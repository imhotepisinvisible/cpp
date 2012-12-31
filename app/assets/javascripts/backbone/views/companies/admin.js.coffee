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

  logoUploadInitialize: ->
    $('#file-logo').fileupload
      singleFileUploads: true
      url: '/companies/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploaddone", (e, data) =>
      window.history.back()
      notify 'success', 'Company saved'

    .bind "fileuploadfail", (e, data) =>
      displayJQZHRErrors data

  delDocument: ->
    $('.company-logo-image').attr('src', '/assets/default_profile.png')

  deleteDocument: ->
    $.ajax
      url: "/companies/#{@model.id}/documents/logo"
      type: 'DELETE'
      success: (data) ->
        window.history.back()
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
    @form.on "change", =>
      @form.validate()
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
        success: (model, response) =>
          if $('#file-logo').get(0).files.length > 0
            @logoUploadInitialize()
            $('#file-logo').fileupload 'send',
              files: $('#file-logo').get(0).files
          else if $('.company-logo-image').attr('src') == '/assets/default_profile.png'
            @deleteDocument()
          else
            window.history.back()
            notify "success", "Company saved"
            @undelegateEvents()
        error: (model, response) =>
          try
            errorlist = JSON.parse response.responseText
            if response.errors
              window.displayErrorMessages response.errors
            else
              notify 'error', 'Unable to save company'
          catch err
            notify 'error', response.responseText