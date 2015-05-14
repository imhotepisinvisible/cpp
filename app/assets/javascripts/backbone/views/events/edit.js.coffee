CPP.Views.Events ||= {}

class CPP.Views.Events.Edit extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/events/editval']

  # Bind event listers
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitEvent'

  # On creating event:
  # Department admins don't get to select departments, it is marked as their own
  # Companies get to pick which departments their events will go to
  initialize: ->
    if (this.options.department)
      swapDepartmentToCompanySchema @model, this.options.department

    # Create event form based upon model
    # Set up skills, interests and year TagEditors for event

    @form = new Backbone.Form(model: @model)
    Backbone.Validation.bind @form;

    @skill_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'skill_list'
      title: 'Skills'
      url: '/tags/skills'
      tag_class: 'label-success'
      additions: true

    @interest_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'interest_list'
      title: 'Interests'
      url: '/tags/interests'
      tag_class: 'label-warning'
      additions: true

    @render()


  # Validate form fields seperatly
  # Set up tags el
  render: ->
    $(@el).html(@template(event: @model))
    super
    $('.form').append(@form.render().el)

    validateField(@form, field) for field of @form.fields

    @skill_list_tags_form.render()
    @interest_list_tags_form.render()
    $('.skill-tags-form').append(@skill_list_tags_form.el)
    $('.interest-tags-form').append(@interest_list_tags_form.el)
    @

  # If event is valid update and update on server
  # On success navigate to events list
  submitEvent: ->
    if @form.validate() == null
      @form.commit()
      if (moment(@model.get("deadline")).diff(moment("0000-01-01T01:00:00+00:00")) == 0)
        @model.set({ deadline: null })
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Event Saved"
          Backbone.history.navigate('events/' + @model.get('id'), trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save event, please resolve issues below."
