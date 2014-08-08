class CPP.Models.Course extends Backbone.Model
  

class CPP.Collections.Courses extends Backbone.Collection
  url: '/courses'
  model: CPP.Models.Course
