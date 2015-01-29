class CPP.Models.Course extends Backbone.Model

  url: ->
    '/courses' + (if @isNew() then '' else '/' + @id)
  

class CPP.Collections.Courses extends Backbone.Collection
  url: '/courses'
  model: CPP.Models.Course
