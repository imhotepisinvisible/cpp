CPP.Views.Placements ||= {}

class CPP.Views.Placements.Edit extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/placements/editval']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitPlacement'

  initialize: ->
    if (this.options.department) 
      swapDepartmentToCompanySchema @model, this.options.department

    @form = new Backbone.Form(model: @model).render()

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

    @year_group_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'year_group_list'
      title: 'Year Groups'
      url: '/tags/year_groups'
      tag_class: 'label-info'
      additions: true

    @render()

  render: ->
    $(@el).html(@template(placement: @model))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('.form').append(@form.el)
    validateField(@form, field) for field of @form.fields
    @skill_list_tags_form.render()
    $('.skill-tags-form').append(@skill_list_tags_form.el)
    @interest_list_tags_form.render()
    $('.interest-tags-form').append(@interest_list_tags_form.el)
    @year_group_list_tags_form.render()
    $('.year-group-tags-form').append(@year_group_list_tags_form.el)
  @

  submitPlacement: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Placement Saved"
          Backbone.history.navigate('companies/' + @model.get('company_id') + '/placements', trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save placement, please resolve issues below."
