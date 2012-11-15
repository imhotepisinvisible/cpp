class CPP.Views.StudentsView extends CPP.Views.Base
  el: "#app"
  template: JST['students/view']

  events:
    'click #btn-download-cv': 'downloadCV'
    'click .activate' : 'activate'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(student: @model))

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events

    placements_partial = new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements
    @

  downloadCV: ->
    window.location = '/students/' + @model.id + '/download_cv'

  activate: (e) ->
    @model.set "active", (!@model.get "active");
    if (!@model.get "active")
      $('#student-profile-img-container').removeClass('profile-deactivated')
      $('#student-profile-intro').removeClass('profile-deactivated')
      $(e.target).html("Deactivate")
    else
      $('#student-profile-img-container').addClass('profile-deactivated')
      $('#student-profile-intro').addClass('profile-deactivated')
      $(e.target).html("Activate")