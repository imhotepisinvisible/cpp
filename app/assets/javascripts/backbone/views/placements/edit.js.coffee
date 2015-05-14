CPP.Views.Placements ||= {}

# Placement editor form
class CPP.Views.Placements.Edit extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/placements/editval']

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitPlacement'

  # If department in options then swap to associated schema for edit form
  # Render event edit form and tags
  # Setup skill, interest and year tag editors
  initialize: ->
    if (this.options.department)
      swapDepartmentToCompanySchema @model, this.options.department

    @form = new Backbone.Form(model: @model).render()

    @skill_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'skill_list'
      title: 'Skills'
      url: '/tags/skills'
      tag_class: 'sktags'
      additions: true

    @interest_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'interest_list'
      title: 'Interests'
      url: '/tags/interests'
      tag_class: 'sktags'
      additions: true

    @render()

  # Render form and validate fields individually
  # Super called as extending we are extending CPP.Views.Base
  render: ->
    $(@el).html(@template(placement: @model))
    super
    $('.form').append(@form.el)
    validateField(@form, field) for field of @form.fields
    @skill_list_tags_form.render()
    $('.skill-tags-form').append(@skill_list_tags_form.el)
    @interest_list_tags_form.render()
    $('.interest-tags-form').append(@interest_list_tags_form.el)
  @

  # If form validates save placement to server
  submitPlacement: ->
    if @form.validate() == null
      @form.commit()
      if (moment(@model.get("deadline")).diff(moment("0000-01-01T01:00:00+00:00")) == 0)
        @model.set({ deadline: null })
      if (moment(@model.get("interview_date")).diff(moment("0000-01-01T01:00:00+00:00")) == 0)
        @model.set({ interview_date: null })
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Placement Saved"
          Backbone.history.navigate('/opportunities/' + model.id, trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save placement, please resolve issues below."
