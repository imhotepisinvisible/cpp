CPP.Views.Companies ||= {}

class CPP.Views.Companies.Admin extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/companies/admin']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-save': 'save'
    'click .upload-document': 'uploadDocument'
    'click .delete-document': 'delDocument'


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
    @logoUploadInitialize()

  logoUploadInitialize: ->
    $('#file-logo').fileupload
      fileInput: null
      singleFileUploads: true
      url: '/companies/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploaddone", (e, data) =>
      console.log 'done', data
      notify 'success', 'Uploaded successfully'
      #window.history.back()

    .bind "fileuploadfail", (e, data) =>
      displayJQZHRErrors data

  delDocument: ->
    @deleteLogo = true

  deleteDocument: ->
    $.ajax
      url: "/companies/#{@model.id}/documents/logo"
      type: 'DELETE'
      success: (data) ->
        notify('success', 'Logo removed')
        window.history.back()
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

  save: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Company saved"
          if $('#file-logo').get(0).files.length > 0
            $('#file-logo').fileupload 'send',
              files: $('#file-logo').get(0).files
          else if @deleteLogo
            @deleteDocument()
          else
            window.history.back()
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
          
