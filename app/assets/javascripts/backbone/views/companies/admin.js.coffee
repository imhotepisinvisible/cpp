CPP.Views.Companies ||= {}

class CPP.Views.Companies.Admin extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/companies/admin']

  events: -> _.extend {}, CPP.Views.Base::events,
    # 'click .upload-document': 'uploadDocument'
    # 'click .delete-document': 'delDocument'
    # 'change #file-logo': 'fileChange'

    'click #company-name-container': 'companyNameEdit'
    'blur #company-name-input-container': 'companyNameStopEdit'
    'click #company-description-container': 'descriptionEdit'
    'blur #company-description-input-container': 'descriptionStopEdit'
    'click .upload-document': 'uploadDocument'
    'click .delete-document': 'deleteDocument'
    'click #contacts'     : 'editContacts'

    'blur #year-input' : 'changeYear'
    'blur #size-input' : 'changeSize'

    'click #company-hq-container': 'hqEdit'
    'blur #company-hq-input-container':'hqStopEdit'

    'change #sector-select' : 'changeSector'
    'change #select-approval-status' : 'changeApproval'

  # Initialise the company adminstrator form
  initialize: ->
    @model.bind 'change', @render, @
    @render()
    @logoUploadInitialize()

    # Obtain approval status for company
    $('#select-approval-status').val(@model.get('reg_status'))

  # Logo uploader
  logoUploadInitialize: ->
    $('#file-logo').fileupload
      # singleFileUploads: true
      url: '/companies/' + @model.id
      dataType: 'json'
      type: "PUT"

    # .bind "fileuploaddone", (e, data) =>
    #   Backbone.history.navigate('/companies/' + @model.id, trigger: true)
    #   notify 'success', 'Company saved'

    # this bind was added new
    .bind "fileuploaddone", (e, data) =>
      notify 'success', 'Uploaded successfully'
      @model.fetch
        success: =>
          $('.company-logo-image').attr('src', @model.get('logo_url'))
          $(e.target).closest('.upload-container').removeClass('missing-document')
          upload = $(e.target).closest('.upload-container')
          upload.find('.progress-upload').delay(250).slideUp 'slow', ->
            upload.find('.bar').width('0%')
            upload.removeClass('missing-document')

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

  # Mark the logo for deletion
  # delDocument: ->
  #   $('.company-logo-image').attr('src', '/assets/default_profile.png')

  # Delete company logo
  # deleteDocument: ->
  #   $.ajax
  #     url: "/companies/#{@model.id}/logo"
  #     type: 'DELETE'
  #     success: (data) =>
  #       Backbone.history.navigate('/companies/' + @model.id, trigger: true)
  #       notify 'success', 'Company saved'
  #     error: (data) ->
  #       notify('error', "Unable to remove logo")

  # Delete company logo
  deleteDocument: (e) ->
    id = $(e.currentTarget).attr('id')
    if confirm "Are you sure you wish to delete your logo?"
      $.ajax
        url: "/companies/#{@model.id}/logo"
        type: 'DELETE'
        success: (data) ->
          $(e.currentTarget).closest('.upload-container').addClass('missing-document')
          $('.company-logo-image').attr('src', '/assets/default_profile.png')
          notify('success', 'logo removed')

        error: (data) ->
          notify('error', "couldn't remove document")

  uploadDocument: (e) ->
    $(e.currentTarget).closest('.upload-container').find('.file-input').click()

  render: ->
    $(@el).html(@template(company: @model))
    # Super called as extending we are extending CPP.Views.Base
    super
    # $('.form').append(@form.el)
    # Backbone.Validation.bind @form

    # validateField(@form, field) for field of @form.fields

    # Render partials
    new CPP.Views.Events.Partial
      el: $(@el).find('#events-partial')
      company: @model
      collection: @model.events
      editable: true

    new CPP.Views.Placements.Partial
      el: $(@el).find('#placements-partial')
      company: @model
      collection: @model.placements
      editable: true

    new CPP.Views.Companies.EditAdministrators
      el: $(@el).find('#edit-admins')
      company: @model
      header: false

    if @model.get('founded') != null
      for option in $('#year-input').children()
        if parseInt($(option).val()) == @model.get('founded')
          $(option).attr('selected', 'selected')

    if @model.get('size') != null
      for option in $('#size-input').children()
        if $(option).val() == @model.get('size')
          $(option).attr('selected', 'selected')

    # Set the default selected looking_for
    for option in $('#sector-select').children()
      if $(option).val() == @model.get('sector')
        $(option).attr('selected', 'selected')

    @

  # Start editing the company name
  companyNameEdit: ->
    window.inPlaceEdit @model, 'company', 'name'

  # Stop editing the company name
  companyNameStopEdit: ->
    window.inPlaceStopEdit @model, 'company', 'name', 'Click here to add a name!', _.identity

  # Start editing the company description
  descriptionEdit: ->
    window.inPlaceEdit @model, 'company', 'description'

  # Stop editing the company description
  descriptionStopEdit: ->
    window.inPlaceStopEdit @model, 'company', 'description', 'Click here to add a description!', ((desc) ->
      desc.replace(/\n/g, "<br/>"))

  changeYear: (e) ->
    year = parseInt($(e.currentTarget).val())
    if year
      $(e.currentTarget).removeClass('missing')
    else
      year = null
      $(e.currentTarget).addClass('missing')
      return

    @model.set 'founded', year
    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify 'success', 'Year founded updated'
      error: (model, response) =>
        notify 'error', 'Could not update year founded'

  changeSize: (e) ->
    size = $(e.currentTarget).val()
    if size
      $(e.currentTarget).removeClass('missing')
    else
      size = null
      $(e.currentTarget).addClass('missing')
      return

    @model.set 'size', size
    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify 'success', 'Size updated'
      error: (model, response) =>
        notify 'error', 'Could not update size'

  # Show inline git edit
  hqEdit: ->
    window.inPlaceEdit @model, 'company', 'hq'

  # Stop inline git edit and save changes
  hqStopEdit: ->
    window.inPlaceStopEdit @model, 'company', 'hq', 'Click to add a link', ((hq) ->
      hq.replace(/\n/g, "<br/>"))

  # Update field in model and save
  changeSector: (e) ->
    sector = $(e.currentTarget).val()
    @model.set 'sector', sector
    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify "success", "Updated Sector"
      error: (model, response) =>
        notify "error", "Could not update Sector"

    # Update field in model and save
  changeApproval: (e) ->
    status = $(e.currentTarget).val()
    @model.set 'reg_status', status
    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify "success", "Updated Approval Status"
        $('#select-approval-status').val(status)
      error: (model, response) =>
        notify "error", "Could not update approval status"


  editContacts: ->
    Backbone.history.navigate('/companies/' + @model.id + '/company_contacts/edit', trigger: true)

  # When the logo changes, change the image src to the contents
  # of the new logo locally (without uploading so that cancel will
  # not upload)
  fileChange: (e) ->
    logo = $('#file-logo').get(0).files[0]
    reader = new FileReader
    reader.onload = (e) ->
      $('.company-logo-image').attr('src', e.target.result)
    reader.readAsDataURL(logo)
