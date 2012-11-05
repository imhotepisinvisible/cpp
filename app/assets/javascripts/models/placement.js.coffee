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
