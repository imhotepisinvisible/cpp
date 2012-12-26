class CPP.Models.Event extends Backbone.Model
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
    depatments:
      required: true

  schema: ->
    title:
    	type: "Text"
   	start_date:
      type: "DateTime"
      DateEditor: "DatePicker"
   	end_date:
      type: "DateTime"
      DateEditor: "DatePicker"
    deadline:
      type: "DateTime"
      DateEditor: "DatePicker"
    description:
      type: "TextArea"
    location:
      type: "Text"
    capacity: "Text"
    google_map_url: "Text"
    requirementsEnabled:
      type: "Checkboxes"
      options: [""]
      title: "Requirements"
      editorAttrs:
        style: "list-style: none"
      editorClass: "requirements-checkbox"
    requirements:
      type: "TextArea"
      title: ""
      fieldAttrs:
        style: "display:none"
    departments:
      type: "Checkboxes"
      options: @allDepartments
      editorClass: "departments-checkbox"

  getFilled: ->
    #TODO: Calculate on SERVER!!
    Math.floor(Math.random() * @get("capacity")) + 1

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
