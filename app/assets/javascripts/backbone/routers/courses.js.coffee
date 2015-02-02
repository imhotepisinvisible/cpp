class CPP.Routers.Courses extends Backbone.Router
  routes:
    'courses'          : 'index'   
    #'courses/:id/edit' : 'edit'    
    'courses/new'      : 'new'
    # 'courses/:id'      : 'view' #check if show is correct

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

  new: ->
    if !isDepartmentAdmin()
      window.history.back()
      return false
    course = new CPP.Models.Course    
    course.collection = new CPP.Collections.Courses
    new CPP.Views.Courses.New model: course 
