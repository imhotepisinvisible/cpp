class CPP.Models.Department extends Backbone.Model
  url: ->
    '/departments' + (if @isNew() then '' else '/' + @id)


