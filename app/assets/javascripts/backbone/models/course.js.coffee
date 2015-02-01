class CPP.Models.Course extends CPP.Models.Base

  url: ->
    '/courses' + (if @isNew() then '' else '/' + @id)
  

class CPP.Collections.Courses extends CPP.Collections.Base
  url: '/courses'
  model: CPP.Models.Course
