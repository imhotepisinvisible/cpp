CPP.Views.Courses ||= {}

class CPP.Views.Courses.Edit extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/courses/edit']

  # Bind event listers
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitCourse'

  initialize: ->
    @form = new Backbone.Form(model: @model)
    Backbone.Validation.bind @form;
    @render()

  # Validate form fields seperatly
  # Set up tags el
  render: ->
    $(@el).html(@template(course: @model))
    super
    $('.form').append(@form.render().el)
    validateField(@form, field) for field of @form.fields
    @

  # If course is valid update and update on server
  # On success navigate to courses list
  submitCourse: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Course Saved"
          Backbone.history.navigate('courses', trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save course, please resolve issues below."
