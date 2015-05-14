class CPP.Models.Placement extends CPP.Models.Base
  initialize: ->
    @allDepartments = new CPP.Collections.Departments

  url: ->
    '/placements' + (if @isNew() then '' else '/' + @id)

  validation:
    position:
      required: true
    description:
      required: true
    location:
      required: true
    deadline:
      required: true

  schema: ->
    position:
      type: "Text"
      title: "Position*"
    description:
      type: "TextArea"
      rows: 60
      cols: 10
      title: "Description*"
    location:
      type: "Text"
      title: "Location*"
    deadline:
      type: "DateTime"
      DateEditor: "DatePicker"
      title: "Deadline*"
    duration:
      type: "Text"
    salary:
      type: "Text"
    benefits:
      type: "Text"
    application_procedure:
      type: "Text"
      title: "Application Procedure"
    other:
      type: "Text"

  getReadableDate: (field) ->
    moment(@get(field)).format('Do MMMM YYYY - H:mm')

  getTimeAgo: (field) ->
    moment(@get(field)).fromNow()

class CPP.Collections.Placements extends CPP.Collections.Base
  url: '/placements'
  model: CPP.Models.Placement

class CPP.Collections.PlacementsPager extends Backbone.PageableCollection
  model: CPP.Models.Placement
  url: '/placements'
  mode: 'client'

  state:
    pageSize: 20
