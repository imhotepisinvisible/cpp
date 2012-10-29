class CPP.Models.Event extends Backbone.Model
  url: ->
    '/events' + (if @isNew() then '' else '/' + @id) 
  
  schema:
    title:
    	type: "Text"
    	validators: ["required"]
   	start_date:
      type: "Datepicker"
      template: "dateTimePicker"
   	end_date: 
      type: "Datepicker"
      template: "dateTimePicker"
    deadline:
      type: "Datepicker"
      template: "dateTimePicker"
    description: "Text"
    location: "Text"
    capacity: "Text"
    google_map_url: "Text"
