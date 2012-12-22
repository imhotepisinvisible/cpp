class CPP.Models.Department extends Backbone.Model
  url: ->
    '/departments' + (if @isNew() then '' else '/' + @id)

  toString: ->
    return this.get 'name'

class CPP.Collections.Departments extends CPP.Collections.Base
  url: '/departments'
  model: CPP.Models.Department