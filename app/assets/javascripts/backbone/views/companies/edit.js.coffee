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

  initialize: ->
    @model.bind 'change', @render, @
    @render()
    @logoUploadInitialize()


  logoUploadInitialize: ->
    $('#file-logo').fileupload
      url: '/companies/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploaddone", (e, data) =>
      notify 'success', 'Uploaded successfully'
      $('.company-logo-image').attr('src', '/companies/' + @model.id + '/documents/logo')
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

  deleteDocument: (e) ->
    id = $(e.currentTarget).attr('id')
    if confirm "Are you sure you wish to delete your logo?"
      $.ajax
        url: "/companies/#{@model.id}/documents/logo"
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
    $(@el).html(@template(company: @model, tooltip: (loggedIn() and CPP.CurrentUser.get('tooltip'))))
    super

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

    new CPP.Views.TaggedEmails.Partial
      el: $(@el).find('#emails-partial')
      company: @model
      collection: @model.tagged_emails
      editable: true

    new CPP.Views.Companies.StatsPartial
      company: @model
      # el: $(@el).find('#contacts-partial')

    new CPP.Views.Companies.EditAdministrators
      el: $(@el).find('#edit-admins')
      company: @model
      header: true

    new CPP.Views.Companies.DepartmentRequests
      el: $(@el).find('#departments')
      company: @model
    @

  companyNameEdit: ->
    window.inPlaceEdit @model, 'company', 'name'

  companyNameStopEdit: ->
    window.inPlaceStopEdit @model, 'company', 'name', 'Click here to add a name!', _.identity

  descriptionEdit: ->
    window.inPlaceEdit @model, 'company', 'description'

  descriptionStopEdit: ->
    window.inPlaceStopEdit @model, 'company', 'description', 'Click here to add a description!', ((desc) ->
      desc.replace(/\n/g, "<br/>"))
