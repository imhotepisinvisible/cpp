class CPP.Models.Event extends Backbone.Model
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

  schema:
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
        style: "display: none"
