class CPP.Models.Student extends Backbone.Model
  initialize: ->
    @events = new CPP.Collections.Events
    @events.url = '/students/' + this.id + '/events'

    @placements = new CPP.Collections.Placements
    @placements.url = '/students/' + this.id + '/placements'

  url: ->
    '/students' + (if @isNew() then '' else '/' + @id)

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
