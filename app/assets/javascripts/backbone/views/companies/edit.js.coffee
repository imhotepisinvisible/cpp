class CPP.Views.CompaniesEdit extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/edit']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #company-name-container': 'companyNameEdit'
    'blur #company-name-input-container': 'companyNameStopEdit'
    'click #company-description-container': 'descriptionEdit'
    'blur #company-description-input-container': 'descriptionStopEdit'
    'click .upload-document': 'uploadDocument'
    'click .delete-document': 'deleteDocument'

    'blur #year-input' : 'changeYear'
    'blur #size-input' : 'changeSize'

    'click #company-hq-container': 'hqEdit'
    'blur #company-hq-input-container':'hqStopEdit'

    'change #sector-select' : 'changeSector'

  # Company dashboard
  initialize: ->
    @model.bind 'change', @render, @
    @render()
    @logoUploadInitialize()

  # Company logo uploader
  logoUploadInitialize: ->
    $('#file-logo').fileupload
      url: '/companies/' + @model.id
      dataType: 'json'
      type: "PUT"

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

  # Upload company logo
  uploadDocument: (e) ->
    $(e.currentTarget).closest('.upload-container').find('.file-input').click()

  # Render company dashboard
  render: ->
    $(@el).html(@template(company: @model, tooltip: (loggedIn() and CPP.CurrentUser.get('tooltip'))))
    super

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

    new CPP.Views.Contacts.PartialEdit
      el: $(@el).find('#contacts-partial')
      company: @model
      company_id: @model.id
      limit: 3
    new CPP.Views.Emails.Partial
      el: $(@el).find('#emails-partial')
      company: @model
      collection: @model.emails
      editable: true

    # new CPP.Views.Stats.LineGraph
    #   url: "/companies/#{@model.id}/view_stats"
    #   yAxis: 'Views'
    #   title: 'Student Views'
    #   el: $(@el).find('#orders_chart')
    #   type: 'datetime'

    new CPP.Views.Companies.EditAdministrators
      el: $(@el).find('#edit-admins')
      company: @model
      header: true

    new CPP.Views.Companies.DepartmentRequests
      el: $(@el).find('#departments')
      company: @model
    
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


  # Update looking_for field in model and save
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