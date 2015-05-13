CPP.Views.Students ||= {}

# Student edit view
class CPP.Views.Students.Edit extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/edit']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .upload-document': 'uploadDocument'
    'click .delete-document': 'deleteDocument'
    'click #student-bio-container': 'bioEdit'
    'click .remove-tag': 'removeTag'
    'blur #student-bio-input-container': 'bioStopEdit'
    'click #student-name-container': 'nameEdit'
    'blur #student-name-input-container': 'nameStopEdit'
    'submit #skill-tag-form': 'addSkill'
    'change #looking-for-select' : 'changeLookingFor'
    'blur #year-input' : 'changeYear'
    'blur #available-input' : 'changeAvailable'
    'change #student-course-input' : 'changeCourse'
    'keyup #student-name-input-container' : 'stopEditOnEnter'
    'keyup #student-degree-input-container': 'stopEditOnEnter'
    
    'click #student-gitHub-container': 'gitEdit'
    'blur #student-gitHub-input-container':'gitStopEdit'

    'click #student-linkedIn-container': 'linkedInEdit'
    'blur #student-linkedIn-input-container':'linkedInStopEdit'

    'click #student-personal-container': 'personalEdit'
    'blur #student-personal-input-container':'personalStopEdit'

    'click #student-other-container': 'otherEdit'
    'blur #student-other-input-container':'otherStopEdit'


  # Setup skills, interests and year tag editors
  # Initialise uploads and call render
  initialize: ->
    # Auxiliary function, saved model on tag input
    saveModel = ->
      @model.save {},
        success: (model, response) ->
          notify "success", "Updated Profile"
        error: (model, response) ->
          # Notify tag-specific errors here (profanity etc)
          errorlist = JSON.parse response.responseText
          notify "error", "Couldn't Update Profile"
        wait: true
        forceUpdate: true

    @skill_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'skill_list'
      title: 'Skills'
      url: '/tags/skills'
      tag_class: 'sktags'
      tag_change_callback: saveModel
      additions: true

    @interest_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'interest_list'
      title: 'Interests'
      url: '/tags/interests'
      tag_class: 'sktags'
      tag_change_callback: saveModel
      additions: true

    @courses = new CPP.Collections.Courses
    @courses.fetch({async:false})
    
    @render()
    @uploadInitialize 'cv'
    @uploadInitialize 'transcript'
    @uploadInitialize 'covering-letter'
    @profileUploadInitialize()

  # Render student edit template with tags, partials and inline editors
  render: ->
    $(@el).html(@template(student: @model, courses: @courses))
    @skill_list_tags_form.render()
    $('.skill-tags-form').append(@skill_list_tags_form.el)
    @interest_list_tags_form.render()
    $('.interest-tags-form').append(@interest_list_tags_form.el)

    profile_warnings = new CPP.Views.Students.ProfileWarnings
      el: '#profile-warnings-container'
      model: @model
    profile_warnings.render()

    events_partial = new CPP.Views.Events.Partial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events

    placements_partial = new CPP.Views.Placements.Partial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements

    $('#add-skill-tag-input').typeahead
      source: (query, process) =>
        $.get '/tags/skills', {student_id: @model.id}, (data) ->
          tagnames = (tag.name for tag in data)
          process(tagnames)

    # Set the default selected looking_for
    for option in $('#looking-for-select').children()
      if $(option).val() == @model.get('looking_for')
        $(option).attr('selected', 'selected')

    # Set the default selected course
    if @model.get('course_id') != null
      for option in $('#student-course-input').children()
        if parseInt($(option).val()) == @model.get('course_id')
          $(option).attr('selected', 'selected')

    if @model.get('year') != null
      for option in $('#year-input').children()
        if parseInt($(option).val()) == @model.get('year')
          $(option).attr('selected', 'selected')

    if @model.get('available') != null
      for option in $('#available-input').children()
        if $(option).val() == @model.get('available')
          $(option).attr('selected', 'selected')
    super
    @

    # Setup profile picture upload
  profileUploadInitialize: ->
    $('#file-profile-picture').fileupload
      url: '/students/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploaddone", (e, data) =>
      notify 'success', 'Uploaded successfully'
      $('#student-profile-img').attr('src', '/students/' + @model.id + '/documents/profile_picture')
      $(e.target).closest('.upload-container').removeClass('missing-document')
      upload = $(e.target).closest('.upload-container')
      upload.find('.progress-upload').delay(250).slideUp 'slow', ->
        upload.find('.bar').width('0%')
        upload.removeClass('missing-document')

    .bind "fileuploadstart", (e, data) ->
      $(e.currentTarget).closest('.upload-container').find('.progress-upload').slideDown()

    .bind "fileuploadprogress", (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('#progress-profile-picture').width(progress + '%')

    .bind "fileuploadfail", (e, data) =>
      upload = $(e.target).closest('.upload-container')
      upload.find('.progress-upload').delay(250).slideUp 'slow', ->
        upload.find('.bar').width('0%')
      displayJQXHRErrors data

  # Setup document uploads
  uploadInitialize: (documentType) =>
    $('#file-' + documentType).fileupload
      url: '/students/' + @model.id
      dataType: 'json'
      type: "PUT"

    .bind "fileuploadstart", (e, data) ->
      $(e.currentTarget).closest('.upload-container').find('.progress-upload').slideDown()

    .bind "fileuploadprogress", (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('#progress-' + documentType).width(progress + '%')

    .bind "fileuploaddone", (e, data) =>
      upload = $(e.target).closest('.upload-container')
      upload.find('.progress-upload').delay(250).slideUp 'slow', ->
        upload.find('.bar').width('0%')
        upload.removeClass('missing-document')

      notify 'success', 'Uploaded successfully'
      @model.set "cv_file_name", "cv"

    .bind "fileuploadfail", (e, data) =>
      upload = $(e.target).closest('.upload-container')
      upload.find('.progress-upload').delay(250).slideUp 'slow', ->
        upload.find('.bar').width('0%')
      displayJQXHRErrors data

  # Upload a document
  uploadDocument: (e) ->
    $(e.currentTarget).closest('.upload-container').find('.file-input').click()

  # Delete a document, confirm action from deleting document
  deleteDocument: (e) ->
    id = $(e.currentTarget).attr('id')
    documentType = id.substring(id.indexOf('-') + 1).replace("-","_")

    if confirm "Are you sure you wish to delete your #{documentType}?"
      $.ajax
        url: "/students/#{@model.id}/documents/#{documentType}"
        type: 'DELETE'
        success: (data) =>
          $(e.currentTarget).closest('.upload-container').addClass('missing-document')
          if documentType == 'profile_picture'
            $('#student-profile-img').attr('src', '/assets/default_profile.png')
          if documentType == 'cv'
            @model.set("cv_file_name","")
        error: (data) ->
          notify('error', "couldn't remove document")

  # Show inline bio edit
  bioEdit: ->
    window.inPlaceEdit @model, 'student', 'bio'

  # Stop inline bio edit and save changes
  bioStopEdit: ->
    window.inPlaceStopEdit @model, 'student', 'bio', 'Click here to add an About Me!', ((bio) ->
      bio.replace(/\n/g, "<br/>"))

  # Show inline git edit
  gitEdit: ->
    window.inPlaceEdit @model, 'student', 'gitHub'

  # Stop inline git edit and save changes
  gitStopEdit: ->
    window.inPlaceStopEdit @model, 'student', 'gitHub', 'Click here to add a link', ((gitHub) ->
      gitHub.replace(/\n/g, "<br/>"))

  # Show inline git edit
  linkedInEdit: ->
    window.inPlaceEdit @model, 'student', 'linkedIn'

  # Stop inline git edit and save changes
  linkedInStopEdit: ->
    window.inPlaceStopEdit @model, 'student', 'linkedIn', 'Click here to add a link', ((linkedIn) ->
      linkedIn.replace(/\n/g, "<br/>"))

  # Show inline git edit
  personalEdit: ->
    window.inPlaceEdit @model, 'student', 'personal'

  # Stop inline git edit and save changes
  personalStopEdit: ->
    window.inPlaceStopEdit @model, 'student', 'personal', 'Click here to add a link', ((personal) ->
      personal.replace(/\n/g, "<br/>"))

  # Show inline git edit
  otherEdit: ->
    window.inPlaceEdit @model, 'student', 'other'

  # Stop inline git edit and save changes
  otherStopEdit: ->
    window.inPlaceStopEdit @model, 'student', 'other', 'Click to add a link', ((other) ->
      other.replace(/\n/g, "<br/>"))


  # Show inline name edit
  nameEdit: ->
    $('#student-name-container').hide()
    $('#student-name-editor').html(@model.get('first_name') + ' ' + @model.get('last_name'))
    $('#student-name-input-container').show()
    $('#student-name-editor').focus()

  
  # Stop inline name edit, find first and last names and if they are specified and at least one has changed then save changes  
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
        forceUpdate: true
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

  # Remove tag from lists 
  removeTag: (e) ->
    close_div = $(e.currentTarget)
    tag_div = close_div.parent()
    tag_name = tag_div.find(".tag-text").html().trim()
    tag_id = close_div.find("input").val()

    @model.set 'skill_list', (tag for tag in @model.get('skill_list') when tag.name != tag_name)
    @model.set 'interest_list', (tag for tag in @model.get('interest_list') when tag.name != tag_name)
    @model.set 'year_group_list', (tag for tag in @model.get('year_group_list') when tag.name != tag_name)

    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify "success", "Removed Tag"
        tag_div.remove()
      error: (model, response) ->
        notify "error", "Failed to remove tag"

  # Add tag to skill list
  addSkill: (e) ->
    e.preventDefault()
    tagname = $("#add-skill-tag-input").val()
    $("#skill-tag-container").append('<span class="label tag skill-tag"><span class="tag-text">' + tagname + '</span><a class="close remove-tag">×<input type="hidden" value=""></a></span>')

    skilltags = @model.get("skills")
    skilltags.push {id:0, name: tagname}
    @model.set 'skills', skilltags

    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify "success", "Added Tag"
        tag_div.remove()
      error: (model, response) ->
        notify "error", "Failed to add tag"


  # Update looking_for field in model and save
  changeLookingFor: (e) ->
    lookingFor = $(e.currentTarget).val()
    @model.set 'looking_for', lookingFor
    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify "success", "Looking for updated"
      error: (model, response) =>
        notify "error", "Could not update looking for"

  # Update and save year field highlight 
  changeYear: (e) ->
    year = parseInt($(e.currentTarget).val())
    if year
      $(e.currentTarget).removeClass('missing')
    else
      year = null
      $(e.currentTarget).addClass('missing')
      return

    @model.set 'year', year
    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify 'success', 'Year updated'
      error: (model, response) =>
        notify 'error', 'Could not update year'

  # Update and save year field highlight 
  changeAvailable: (e) ->
    available = $(e.currentTarget).val()
    if available
      $(e.currentTarget).removeClass('missing')
    else
      available = null
      $(e.currentTarget).addClass('missing')
      return

    @model.set 'available', available
    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify 'success', 'Availability updated'
      error: (model, response) =>
        notify 'error', 'Could not update when available'

  changeCourse: (e) ->
    courseId = parseInt($(e.currentTarget).val())
    @model.set 'course_id', courseId
    @model.save {},
      wait: true
      forceUpdate: true
      success: (model, response) =>
        notify 'success', 'Course updated'
      error: (model, response) =>
        notify 'error', 'Could not update course'

  # Stop inline edit on enter key press 
  stopEditOnEnter: (e) ->
    if (e.keyCode == 13)
      @nameStopEdit()
      #@degreeStopEdit()
