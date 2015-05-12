class CPP.Models.Event extends CPP.Models.Base
  initialize: ->
    @allDepartments = new CPP.Collections.Departments

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

  # Schema to be used for backbone forms
  schema: ->
    title:
      type: 'Text'
      title: "Title*"
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
      type: "TextArea"
      title: "Location*"
    capacity: "Text"
    departments:
      type: "Checkboxes"
      title: "Department(s)*"
      options: @allDepartments
      editorClass: "departments-checkbox"
    requirements:
      type: "TextArea"
      title: "Additional Requirements"

  # Return the number of students attending the event
  getFilled: ->
    if @.registered_students then @.registered_students.length else 0

  # The percentage of spaces that have been taken
  getPercentageCapacity: ->
    percentage = 100 * parseFloat(@getFilled()) / parseFloat(@get("capacity"))
    return percentage

  # The class to add to the event capacity bar
  getCapacityClass: ->
    p = @getPercentageCapacity()
    return "danger" if p > 90
    return "warning" if p > 60
    return "info"

  # Remaining spaces in the event
  getSpaces: ->
    @get('capacity') - @getFilled()

  getReadableDate: (field) ->
    moment(@get(field)).format('Do MMMM YYYY - H:mm')

  getTimeAgo: (field) ->
    moment(@get(field)).fromNow()

class CPP.Collections.Events extends CPP.Collections.Base
  url: '/events'
  model: CPP.Models.Event


class CPP.Collections.EventsRecent extends CPP.Collections.Base
  url: '/events'
  model: CPP.Models.Event
  sortKey: 'created_at'
  mode: 'infinite'
  comparator: (eventA, eventB) ->
          if eventA.get(this.sortKey) > eventB.get(this.sortKey) then -1
          else if eventB.get(this.sortKey) > eventA.get(this.sortKey) then 1
          else 0
  state:
    pageSize: 3


class CPP.Collections.EventsPager extends Backbone.PageableCollection
  model: CPP.Models.Event
  url: '/events'
  mode: 'client' 

  state:
    pageSize: 20
