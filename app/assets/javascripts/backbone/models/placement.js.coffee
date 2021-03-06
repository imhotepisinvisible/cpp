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
    contact:
      type: 'Text'
      title: "Primary Contact*"
    link:
      type: 'Text'
      title: "External Link"
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
  sortKey: 'created_at'
  comparator: (eventA, eventB) ->
    if eventA.get(this.sortKey) > eventB.get(this.sortKey) then -1
    else if eventB.get(this.sortKey) > eventA.get(this.sortKey) then 1
    else 0

  state:
    pageSize: 20
