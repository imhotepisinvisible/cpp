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
    duration:
      type: "Text"
    salary:
      type: "Text"
    benefits:
      type: "Text"
    application_procedure:
      type: "Text"
      title: "Application Procedure"
    interview_date:
      type: "DateTime"
      title: "Interview Date (If Known)"
      DateEditor: "DatePicker"
    departments:
      type: "Checkboxes"
      title: "Department(s)*"
      options: @allDepartments
      editorClass: "departments-checkbox"
    other:
      type: "Text"

  getReadableDate: (field) ->
    moment(@get(field)).format('Do MMMM YYYY - H:mm')
    
  getTimeAgo: (field) ->
    moment(@get(field)).fromNow()
    
class CPP.Collections.Placements extends CPP.Collections.Base
  url: '/placements'
  model: CPP.Models.Placement

class CPP.Collections.PlacementsRecent extends CPP.Collections.Base
  url: '/placements'
  model: CPP.Models.Placement
  sortKey: 'created_at'
  comparator: (placementA, placementB) ->
          if placementA.get(this.sortKey) > placementB.get(this.sortKey) then -1
          else if placementB.get(this.sortKey) > placementA.get(this.sortKey) then 1
          else 0
                  
class CPP.Collections.PlacementsPager extends Backbone.PageableCollection
  model: CPP.Models.Placement
  url: '/placements'
  mode: 'client' 

  state:
    pageSize: 20
