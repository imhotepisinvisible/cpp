class CPP.Models.Placement extends CPP.Models.Base
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
      type: "Text"
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
      options: new CPP.Collections.Departments
      editorClass: "departments-checkbox"
    other:
      type: "Text"

  getReadableDate: (field) ->
    Date.parse(@get(field)).toString('dS MMMM yyyy - H:mm')

class CPP.Collections.Placements extends CPP.Collections.Base
  url: '/placements'
  model: CPP.Models.Placement
