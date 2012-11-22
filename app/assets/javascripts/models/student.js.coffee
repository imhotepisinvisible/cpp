class CPP.Models.Student extends Backbone.Model
  initialize: ->
    @events = new CPP.Collections.Events
    @events.url = '/students/' + this.id + '/events'

    @placements = new CPP.Collections.Placements
    @placements.url = '/students/' + this.id + '/placements'

  url: ->
    '/students' + (if @isNew() then '' else '/' + @id)

  validation:
    first_name:
      required: true
    last_name:
      required: true
    email:
      required: true
      pattern: 'email'
    password:
      required: true
      minLength: 8
    password_confirmation:
      required: true
      minLength: 8

  schema:
    first_name:
      type: "Text"
      title: "First Name"
    last_name:
      type: "Text"
      title: "Last Name"
    email:
      type: "Text"
      title: "Email"
    password:
      type: "Password"
    password_confirmation:
      type: "Password"
      title: "Password Confirmation"
    skill_list:
      type: "Tag"
    interest_list:
      type: "Tag"
    year_group_list:
      type: "Tag"

