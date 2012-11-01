class CPP.Models.Placement extends Backbone.Model
  url: ->
    '/placements' + (if @isNew() then '' else '/' + @id)

  schema:
    position:
      type: "Text"
      validators: ["required"]
    description:
      type: "Text"
      validators: ["required"]
    duration: 
      type: "Text"
      validators: ["required"]
    location:
      type: "Text"
      validators: ["required"]
    deadline: 
      type: "DateTime"
      DateEditor: "DatePicker"
