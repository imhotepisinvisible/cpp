class CPP.Views.StudentsEdit extends CPP.Views.Base
  el: "#app"
  template: JST['students/edit']

  events:
    'click .upload-document': 'uploadDocument'
    'click .delete-document': 'deleteDocument'

    'click #bio-container': 'bioEdit'
    'click .remove-tag': 'removeTag'
    'blur #bio-input-container': 'bioStopEdit'
    'click #name-container': 'nameEdit'
    'blur #name-input-container': 'nameStopEdit'
    'click #year-container': 'yearEdit'
    'blur #year-input-container': 'yearStopEdit'
    'click #degree-container': 'degreeEdit'
    'blur #degree-input-container': 'degreeStopEdit'
    'click .activate'  : 'activate'
    'submit #skill-tag-form': 'addSkill'

  initialize: ->
    @render()
    @uploadInitialize 'cv'
    @uploadInitialize 'transcript'
    @uploadInitialize 'covering-letter'
    @profileUploadInitialize()

  render: ->
    super
    $(@el).html(@template(student: @model))

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

    @

  profileUploadInitialize: ->
    $('#file-profile-picture').fileupload
      url: '/students/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploaddone", (e, data) =>
      notify 'success', 'Uploaded successfully'
      $('#student-profile-img').attr('src', '/students/' + @model.id + '/profile_picture')
      $(e.target).closest('.upload-container').removeClass('missing-document')

    .bind "fileuploadfail", (e, data) ->
      notify('error', "Document couldn't be uploaded")

  uploadInitialize: (documentType) ->
    $('#file-' + documentType).fileupload
      url: '/students/' + @model.id
      dataType: 'json'
      type: "PUT"


    .bind "fileuploadstart", (e, data) ->
      $(e.currentTarget).parent().parent().parent().find('.progress-upload').slideDown()

    .bind "fileuploadprogress", (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('#progress-' + documentType).width(progress + '%')

    .bind "fileuploaddone", (e, data) ->
      td = $(e.target).closest('td')
      td.find('.progress-upload').delay(250).slideUp 'slow', ->
        td.find('.bar').width('0%')
        td.removeClass('missing-document')
        notify 'success', 'Uploaded successfully'

    .bind "fileuploadfail", (e, data) ->
      td = $(e.target).closest('td')
      td.find('.progress-upload').delay(250).slideUp 'slow', ->
        td.find('.bar').width('0%')
      notify('error', "Document couldn't be uploaded")

  uploadDocument: (e) ->
    $(e.currentTarget).closest('.upload-container').find('.file-input').click()

  deleteDocument: (e) ->
    id = $(e.currentTarget).attr('id')
    documentType = id.substring(id.indexOf('-') + 1).replace("-","_")

    if confirm "Are you sure you wish to delete your #{documentType}?"
      $.ajax
        url: "/students/#{@model.id}/#{documentType}"
        type: 'DELETE'
        success: (data) ->
          $(e.currentTarget).closest('.upload-container').addClass('missing-document')
          if documentType == 'profile_picture'
            $('#student-profile-img').attr('src', '/assets/default_profile.png')

        error: (data) ->
          notify('error', "couldn't remove document")

  bioEdit: ->
    @edit 'bio'

  bioStopEdit: ->
    @stopEdit 'bio', 'Click here to add an About Me!', ((bio) ->
      bio.replace(/\n/g, "<br/>"))

  yearEdit: ->
    @edit 'year'

  yearStopEdit: ->
    @stopEdit 'year', 'N/A', ((year) ->
      if year then getOrdinal year else '')

  degreeEdit: ->
    @edit 'degree'

  degreeStopEdit: ->
    @stopEdit 'degree', 'N/A degree', _.identity

  # displayFunction must take one argument - the value in the model and
  # must output a string to display in the edit window
  stopEdit: (attribute, defaultValue, displayFunction) ->
    value = $('#student-' + attribute + '-editor').val()
    $('#' + attribute + '-input-container').hide()

    if value != @model.get attribute
      @model.set attribute, value
      @model.save {},
          wait: true
          success: (model, response) =>
            notify "success", "Updated profile"
            display = displayFunction(model.get(attribute))
            if display
              $('#student-' + attribute).html display
              $('#student-' + attribute).removeClass('missing')
            else
              $('#student-' + attribute).html defaultValue
              $('#student-' + attribute).addClass('missing')

            @model.set attribute, model.get(attribute)
          error: (model, response) ->
            errorlist = JSON.parse response.responseText
            msg = errorlist.errors.bio.join('\n')
            notify "error", msg

    $('#' + attribute + '-container').show()

  edit: (attribute) ->
    $('#' + attribute + '-container').hide()
    $('#student-' + attribute + '-editor').html(@model.get attribute)
    $('#' + attribute + '-input-container').show()
    $('#student-' + attribute + '-editor').focus()

  nameEdit: ->
    $('#name-container').hide()
    $('#student-name-editor').html(@model.get('first_name') + ' ' + @model.get('last_name'))
    $('#name-input-container').show()
    $('#student-name-editor').focus()

  nameStopEdit: ->
    name = $('#student-name-editor').val()
    lastName = name.substring(name.indexOf(' ') + 1)
    firstName = name.substring(0, name.indexOf(' '))
    $('#name-input-container').hide()

    if not ((firstName == @model.get 'first_name') and (lastName == @model.get 'last_name'))
      @model.set 'first_name', firstName
      @model.set 'last_name', lastName
      @model.save {},
          wait: true
          success: (model, response) =>
            notify "success", "Updated profile"
            $('#student-profile-intro-name').html(model.get('first_name') + ' ' + model.get('last_name'))
            @model.set 'first_name', model.get('first_name')
            @model.set 'last_name', model.get('last_name')
          error: (model, response) ->
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

    $('#name-container').show()

  activate: (e)->
    @model.set "active", (!@model.get "active");
    if (!@model.get "active")
      $('#student-profile-img-container').addClass('profile-deactivated')
      $('#student-profile-intro').addClass('profile-deactivated')
      $(e.target).html("Activate")
    else
      $('#student-profile-img-container').removeClass('profile-deactivated')
      $('#student-profile-intro').removeClass('profile-deactivated')
      $(e.target).html("Deactivate")
    @model.save {},
        wait: true
        success: (model, response) =>
          if @model.get "active"
            notify "success", "Profile Active"
          else
            notify "success", "Profile Inactive"
        error: (model, response) ->
          notify "error", "Failed to change profile active status"

  removeTag: (e) ->
    close_div = $(e.currentTarget)
    tag_div = close_div.parent()
    tag_name = tag_div.find(".tag-text").html().trim()
    tag_id = close_div.find("input").val()

    console.log tag_name

    # Remove tag from lists
    @model.set 'skills', (tag for tag in @model.get('skills') when tag.name != tag_name)
    @model.set 'interests', (tag for tag in @model.get('interests') when tag.name != tag_name)
    @model.set 'year_groups', (tag for tag in @model.get('year_groups') when tag.name != tag_name)

    console.log @model.get('year_groups')
    console.log(parseInt(tag.id), parseInt(tag_id)) for tag in @model.get('year_groups')
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

    console.log @model.get("skills")
    @model.save {},
      wait: true
      success: (model, response) =>
        notify "success", "Added Tag"
        tag_div.remove()
      error: (model, response) ->
        notify "error", "Failed to add tag"
