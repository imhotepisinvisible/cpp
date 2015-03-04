class CPP.Models.Course extends CPP.Models.Base

  url: ->
    '/courses' + (if @isNew() then '' else '/' + @id)
    
  validation:
    name:
      required: true
      maxLength: 100

  schema: ->
    name:
      type: 'Text'
      title: 'Name'    

class CPP.Collections.Courses extends CPP.Collections.Base
  url: '/courses'
  model: CPP.Models.Course
