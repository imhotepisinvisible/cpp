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
   	end_date: 
      type: "DateTime"
      DateEditor: "DatePicker"
    deadline:
      type: "DateTime"
      DateEditor: "DatePicker"
    description: "Text"
    location: "Text"
    capacity: "Text"
    google_map_url: "Text"
