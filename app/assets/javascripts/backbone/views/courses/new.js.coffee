# New Course page
class CPP.Views.Courses.New extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/courses/new']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submit'

  initialize: (options) ->
    @form = new Backbone.Form(model: @model).render() 
    @render()
    
  render: ->
    $(@el).html(@template(course: @model))
    super
    $('#signup-form').append(@form.el)
    Backbone.Validation.bind @form
    validateField(@form, field) for field of @form.fields
    @

  submit: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Registered"          
          Backbone.history.navigate("/courses", trigger: true)
        error: (model, response) =>
          if response.responseText
            errorlist = JSON.parse response.responseText
            for field, errors of errorlist.errors
              if field of @form.fields
                @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to register, please resolve issues below." 
          
