class CPP.Models.Event extends Backbone.Model
  url: ->
    '/events' + (if @isNew() then '' else '/' + @id) 

  schema:
    title:
    	type: "Text"
    	validators: ["required"]
   	start_date:
      type: "DateTime"
      DateEditor: "DatePicker"
      validators: ["required"]
   	end_date: 
      type: "DateTime"
      DateEditor: "DatePicker"
      validators: ["required"]
    deadline:
      type: "DateTime"
      DateEditor: "DatePicker"
    description: 
      type: "TextArea"
      validators: ["required"]
    location:
      type: "Text"
      validators: ["required"]
    capacity: "Text"
    google_map_url: "Text"
