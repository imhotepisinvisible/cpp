class CPP.Views.StudentsView extends CPP.Views.Base
  el: "#app"
  template: JST['students/view']

  events:
    'click #btn-download-cv': 'downloadCV'

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