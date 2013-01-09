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
    description:
      required: true
    location:
      required: true
    departments:
      required: true

  schema: ->
    title: { type: 'TextArea', title: "Title*" }
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
    departments:
      type: "Checkboxes"
      title: "Department(s)*"
      options: new CPP.Collections.Departments
      editorClass: "departments-checkbox"
    requirements:
      type: "TextArea"
      title: "Additional Requirements"

  getFilled: ->
    if @.registered_students then @.registered_students.length else 0

  getPercentageCapacity: ->
    percentage = 100 * parseFloat(@getFilled()) / parseFloat(@get("capacity"))
    return percentage

  getCapacityClass: ->
    p = @getPercentageCapacity()
    return "danger" if p > 90
    return "warning" if p > 60
    return "info"

  getSpaces: ->
    @get('capacity') - @getFilled()

  getReadableDate: (field) ->
    Date.parse(@get(field)).toString('dS MMMM yyyy - H:mm')

class CPP.Collections.Events extends CPP.Collections.Base
  url: '/events'
  model: CPP.Models.Event
