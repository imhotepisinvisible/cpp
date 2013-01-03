class CPP.Models.Event extends CPP.Models.Base
  initialize: ->
    @allDepartments = new CPP.Collections.Departments
    @allDepartments.url = '/departments'

  url: ->
    '/events' + (if @isNew() then '' else '/' + @id)

  validation:
    title:
      required: true
    start_date:
      required: true
    end_date:
      required: true
    google_map_url:
      pattern: 'url'
    description:
      required: true
    location:
      required: true
    departments:
      required: true

  schema: ->
    title:
    	type: "Text",
   	start_date:
      type: "DateTime"
      title: "Start Date*"
      DateEditor: "DatePicker"
   	end_date:
      type: "DateTime"
      title: "End Date*"
      DateEditor: "DatePicker"
    deadline:
      type: "DateTime"
      DateEditor: "DatePicker"
    description:
      type: "TextArea"
      title: "Description*"
    location:
      type: "Text"
      title: "Location*"
    capacity: "Text"
    google_map_url: 
      type: "Text"
      title: "Google Map URL*"
      validators: ['required']
    requirementsEnabled:
      type: "Checkboxes"
      title: "Extra Requirements?"
      options: [""]
      editorAttrs:
        style: "list-style: none"
      editorClass: "requirements-checkbox"
    requirements:
      type: "TextArea"
      title: ""
      fieldAttrs:
        style: "display:none"
    departments:
      title: "Department(s)*"
      type: "Checkboxes"
      options: @allDepartments
      editorClass: "departments-checkbox"

  getFilled: ->
    @.registered_students.length

  getPercentageCapacity: ->
    percentage = 100 * parseFloat(@getFilled()) / parseFloat(@get("capacity"))
    return percentage

  getCapacityClass: ->
    p = @getPercentageCapacity()
    return "danger" if p > 90
    return "warning" if p > 60
    return "info"

  getReadableDate: (field) ->
    Date.parse(@get(field)).toString('dS MMMM yyyy - H:mm')

class CPP.Collections.Events extends CPP.Collections.Base
  url: '/events'
  model: CPP.Models.Event
