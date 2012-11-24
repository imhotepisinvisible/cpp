class CPP.Views.StudentsEdit extends CPP.Views.Base
  el: "#app"
  template: JST['students/edit']

  events:
    'click .upload-document': 'uploadDocument'
    'click .delete-document': 'deleteDocument'
    'click #student-bio-container': 'bioEdit'
    'click .remove-tag': 'removeTag'
    'blur #student-bio-input-container': 'bioStopEdit'
    'click #student-name-container': 'nameEdit'
    'blur #student-name-input-container': 'nameStopEdit'
    'click #student-year-container': 'yearEdit'
    'blur #student-year-input-container': 'yearStopEdit'
    'click #student-degree-container': 'degreeEdit'
    'blur #student-degree-input-container': 'degreeStopEdit'
    'click #activate-button'  : 'activate'
    'submit #skill-tag-form': 'addSkill'
    'click .toggle' : 'toggle'

  initialize: ->

    saveModel = ->
      @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Updated Profile"
        error: (model, response) ->
          # Notify tag-specific errors here (profanity etc)
          errorlist = JSON.parse response.responseText
          notify "error", "Couldn't Update Profile"

    @skill_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'skill_list'
      title: 'Skills'
      url: '/tags/skills'
      tag_class: 'label-success'
      tag_change_callback: saveModel
      additions: true

    @interest_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'interest_list'
      title: 'Interests'
      url: '/tags/interests'
      tag_class: 'label-warning'
      tag_change_callback: saveModel
      additions: true

    @year_group_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'year_group_list'
      title: 'Year Groups'
      url: '/tags/year_groups'
      tag_class: 'label-info'
      tag_change_callback: saveModel
      additions: true

    @render()
    @updateActiveView()
    @uploadInitialize 'cv'
    @uploadInitialize 'transcript'
    @uploadInitialize 'covering-letter'
    @profileUploadInitialize()


  render: ->
    super
    $(@el).html(@template(student: @model))

    @skill_list_tags_form.render()
    $('.skill-tags-form').append(@skill_list_tags_form.el)
    @interest_list_tags_form.render()
    $('.interest-tags-form').append(@interest_list_tags_form.el)
    @year_group_list_tags_form.render()
    $('.year-group-tags-form').append(@year_group_list_tags_form.el)

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events

    placements_partial = new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements

    $('#add-skill-tag-input').typeahead
      source: (query, process) =>
        $.get '/tags/skills', {student_id: @model.id}, (data) ->
          tagnames = (tag.name for tag in data)
          process(tagnames)

    $('#student-degree-editor').typeahead
      source: (query, process) =>
        $.get '/students/suggested_degrees', {}, (data) ->
          process(data)
    @

  profileUploadInitialize: ->
    $('#file-profile-picture').fileupload
      url: '/students/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploaddone", (e, data) =>
      notify 'success', 'Uploaded successfully'
      $('#student-profile-img').attr('src', '/students/' + @model.id + '/documents/profile_picture')
      $(e.target).closest('.upload-container').removeClass('missing-document')

    .bind "fileuploadfail", (e, data) =>
      @displayJQXHRErrorMessage data

  uploadInitialize: (documentType) ->
    $('#file-' + documentType).fileupload
      url: '/students/' + @model.id
      dataType: 'json'
      type: "PUT"


    .bind "fileuploadstart", (e, data) ->
      $(e.currentTarget).closest('.upload-container').find('.progress-upload').slideDown()

    .bind "fileuploadprogress", (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('#progress-' + documentType).width(progress + '%')

    .bind "fileuploaddone", (e, data) ->
      upload = $(e.target).closest('.upload-container')
      upload.find('.progress-upload').delay(250).slideUp 'slow', ->
        upload.find('.bar').width('0%')
        upload.removeClass('missing-document')

      notify 'success', 'Uploaded successfully'

    .bind "fileuploadfail", (e, data) =>
      upload = $(e.target).closest('.upload-container')
      upload.find('.progress-upload').delay(250).slideUp 'slow', ->
        upload.find('.bar').width('0%')
      @displayJQXHRErrorMessage data


  displayJQXHRErrorMessage: (data) ->
    response = JSON.parse data.jqXHR.responseText
    if response.errors
      messages = []
      for attr, error of response.errors
        messages.push error

    if !messages
      msg = 'Error'
    else
      msg = messages.join(', ')

    notify('error', msg)

  uploadDocument: (e) ->
    $(e.currentTarget).closest('.upload-container').find('.file-input').click()

  deleteDocument: (e) ->
    id = $(e.currentTarget).attr('id')
    documentType = id.substring(id.indexOf('-') + 1).replace("-","_")

    if confirm "Are you sure you wish to delete your #{documentType}?"
      $.ajax
        url: "/students/#{@model.id}/documents/#{documentType}"
        type: 'DELETE'
        success: (data) ->
          $(e.currentTarget).closest('.upload-container').addClass('missing-document')
          if documentType == 'profile_picture'
            $('#student-profile-img').attr('src', '/assets/default_profile.png')

        error: (data) ->
          notify('error', "couldn't remove document")

  bioEdit: ->
    window.inPlaceEdit @model, 'student', 'bio'

  bioStopEdit: ->
    window.inPlaceStopEdit @model, 'student', 'bio', 'Click here to add an About Me!', ((bio) ->
      bio.replace(/\n/g, "<br/>"))

  yearEdit: ->
    window.inPlaceEdit @model, 'student', 'year'

  yearStopEdit: ->
    window.inPlaceStopEdit @model, 'student', 'year', 'N/A', ((year) ->
      if year then getOrdinal year else '')

  degreeEdit: ->
    window.inPlaceEdit @model, 'student', 'degree'

  degreeStopEdit: ->
    window.inPlaceStopEdit @model, 'student', 'degree', 'N/A degree', _.identity

  nameEdit: ->
    $('#student-name-container').hide()
    $('#student-name-editor').html(@model.get('first_name') + ' ' + @model.get('last_name'))
    $('#student-name-input-container').show()
    $('#student-name-editor').focus()

  nameStopEdit: ->
    originalName = @model.get('first_name') + ' ' + @model.get('last_name')
    name = $('#student-name-editor').val()
    lastName = name.substring(name.indexOf(' ') + 1)
    firstName = name.substring(0, name.indexOf(' '))

    $('#student-name-input-container').hide()

    if not lastName or not firstName
      notify "error", 'Must specify first name and last name separated by a space.'
      $('#student-profile-intro-name').html originalName
      $('#student-name-editor').val(originalName)
    else if not ((firstName == @model.get 'first_name') and (lastName == @model.get 'last_name'))
      @model.set 'first_name', firstName
      @model.set 'last_name', lastName
      @model.save {},
          wait: true
          success: (model, response) =>
            notify "success", "Updated profile"
            $('#student-profile-intro-name').html(model.get('first_name') + ' ' + model.get('last_name'))
          error: (model, response) =>
            errorlist = JSON.parse response.responseText
            if errorlist.errors.first_name
              msg = errorlist.errors.first_name
            else
              msg = []
            if errorlist.errors.last_name
              for error in errorlist.errors.last_name
                if !(error in msg)
                  msg.push error
            notify "error", msg.join('\n')
            $('#student-profile-intro-name').html originalName

    $('#student-name-container').show()

  activate: (e)->
    @model.set "active", (!@model.get "active");
    @updateActiveView();
    @model.save {},
        wait: true
        success: (model, response) =>
          $("#profile-inactive-warning").slideToggle()
          if @model.get "active"
            notify "success", "Profile Active"
          else
            notify "success", "Profile Inactive"
        error: (model, response) ->
          notify "error", "Failed to change profile active status"

  updateActiveView: ->
    if (!@model.get "active")
      $('#student-profile-img-container').addClass('profile-deactivated')
      $('#student-profile-intro').addClass('profile-deactivated')
      $('#activate-button').html("Activate")
    else
      $('#student-profile-img-container').removeClass('profile-deactivated')
      $('#student-profile-intro').removeClass('profile-deactivated')
      $('#activate-button').html("Deactivate")

  removeTag: (e) ->
    close_div = $(e.currentTarget)
    tag_div = close_div.parent()
    tag_name = tag_div.find(".tag-text").html().trim()
    tag_id = close_div.find("input").val()

    # Remove tag from lists
    @model.set 'skills', (tag for tag in @model.get('skills') when tag.name != tag_name)
    @model.set 'interests', (tag for tag in @model.get('interests') when tag.name != tag_name)
    @model.set 'year_groups', (tag for tag in @model.get('year_groups') when tag.name != tag_name)

    @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Removed Tag"
          tag_div.remove()
        error: (model, response) ->
          notify "error", "Failed to remove tag"

  addSkill: (e) ->
    e.preventDefault()
    tagname = $("#add-skill-tag-input").val()
    $("#skill-tag-container").append('<span class="label tag skill-tag"><span class="tag-text">' + tagname + '</span><a class="close remove-tag">×<input type="hidden" value=""></a></span>')

    skilltags = @model.get("skills")
    skilltags.push {id:0, name: tagname}
    @model.set 'skills', skilltags

    @model.save {},
      wait: true
      success: (model, response) =>
        notify "success", "Added Tag"
        tag_div.remove()
      error: (model, response) ->
        notify "error", "Failed to add tag"

  toggle: (e) ->
    $('#student-profile-body').slideToggle 'fast', ->
      toggle = $('#student-profile-toggle')
      if $('#student-profile-body').is ":hidden"
        toggle.find('i').removeClass('icon-caret-up')
        toggle.find('i').addClass('icon-caret-down')
      else
        toggle.find('i').removeClass('icon-caret-down')
        toggle.find('i').addClass('icon-caret-up')
        icon = 'icon-caret-up'
