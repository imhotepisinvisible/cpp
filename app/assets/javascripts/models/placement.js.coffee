class CPP.Models.Placement extends Backbone.Model
  url: ->
    '/placements' + (if @isNew() then '' else '/' + @id)
