class CPP.Models.Student extends Backbone.Model
  initialize: ->
  	console.log "init student"

  url: ->
    '/students' + (if @isNew() then '' else '/' + @id)