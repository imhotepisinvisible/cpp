class CPP.Routers.Courses extends Backbone.Router
  routes:
    'courses'          : 'index'
   # 'courses/:id'      : 'view' #check if show is correct
   # 'courses/:id/edit' : 'edit'
   # 'courses/new'      : 'new'

  index: ->
    if !isDepartmentAdmin()
      window.history.back()
      return false
    courses = new CPP.Collections.Courses
    courses.fetch
      success: ->
        view = new CPP.Views.Courses.Index collection: courses
      error: ->
        notify "error", "Couldn't fetch courses"
    
  #view: (id) ->
  #  courses = new CPP.Models.course
  #  courses.fetch
  #  new CPP.Vies.Courses.
