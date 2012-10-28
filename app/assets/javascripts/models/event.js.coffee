class CPP.Models.Event extends Backbone.Model
  url: ->
    '/events' + (if @isNew() then '' else '/' + @id) 
  
  schema:
    title:
    	type: "Text"
    	validators: ["required"]
   	start_date: "Date"
   	end_date: "Date"
    deadline: "Date"
    desctiption: "Text"
    location: "Text"
    capacity: "Text"
    google_map_url: "Text"