class CPP.Views.CompaniesEdit extends CPP.Views.Base
  el: "#app"
  template: JST['companies/edit']

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
      console.log "Success"
      notify 'success', 'Uploaded successfully'
      $('.company-logo-img').attr('src', '/companies/' + @model.id + '/documents/logo')
      $(e.target).closest('.upload-container').removeClass('missing-document')

    .bind "fileuploadfail", (e, data) =>
      console.log "Failure"
      displayJQZHRErrors data

  deleteDocument: (e) ->
    id = $(e.currentTarget).attr('id')
    if confirm "Are you sure you wish to delete your logo?"
      $.ajax
        url: "/companies/#{@model.id}/documents/logo"
        type: 'DELETE'
        success: (data) ->
          $(e.currentTarget).closest('.upload-container').addClass('missing-document')
          $('.company-logo-img').attr('src', '/assets/default_profile.png')
          notify('success', 'logo removed')

        error: (data) ->
          notify('error', "couldn't remove document")

  uploadDocument: (e) ->
    $(e.currentTarget).closest('.upload-container').find('.file-input').click()

  render: ->
    $(@el).html(@template(company: @model))

    new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events
      editable: true

    new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements
      editable: true

    new CPP.Views.ContactsPartialEdit
      el: $(@el).find('#contacts-partial')
      company: @model
      company_id: @model.id
      limit: 3
    

    new CPP.Views.TaggedEmailsPartial
      el: $(@el).find('#emails-partial')
      model: @model
      collection: @model.emails
      editable: true

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