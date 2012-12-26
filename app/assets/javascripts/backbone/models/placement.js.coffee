class CPP.Models.Placement extends Backbone.Model
  url: ->
    '/placements' + (if @isNew() then '' else '/' + @id)

  validation:
    position:
      required: true
    description:
      required: true
    location:
      required: true

  schema:
    position:
      type: "Text"
    description:
      type: "Text"
    location:
      type: "Text"
    deadline:
      type: "DateTime"
      DateEditor: "DatePicker"
    duration:
      type: "Text"
    open_to:
      type: "Text"
    salary:
      type: "Text"
    benefits:
      type: "Text"
    application_procedure:
      type: "Text"
    interview_date:
      type: "DateTime"
      title: "Interview Date (If Known)"
      DateEditor: "DatePicker"
    other:
      type: "Text"

  getReadableDate: (field) ->
    Date.parse(@get(field)).toString('dS MMMM yyyy - H:mm')

class CPP.Collections.Placements extends CPP.Collections.Base
  url: '/placements'
  model: CPP.Models.Placement
