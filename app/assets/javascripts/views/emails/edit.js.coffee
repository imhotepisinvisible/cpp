class CPP.Views.EmailsEdit extends CPP.Views.Base
  el: "#app"

  template: JST['emails/editval']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitEmail'

  initialize: ->
    @form = new Backbone.Form(model: @model).render()

    @skill_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'skill_list'
      title: 'Skills'
      url: '/tags/skills'
      tag_class: 'label-success'
      tag_change_callback: =>
        @skill_list_tags_form.commit()
        console.log @

    @interest_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'interest_list'
      title: 'Interests'
      url: '/tags/interests'
      tag_class: 'label-warning'
      tag_change_callback: =>
        @interest_list_tags_form.commit()
        console.log @

    @year_group_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'year_group_list'
      title: 'Year Groups'
      url: '/tags/year_groups'
      tag_class: 'label-info'
      tag_change_callback: =>
        @year_group_list_tags_form.commit()
        console.log @

    @render()


  render: ->
    super
    $(@el).html(@template(email: @model))

    @skill_list_tags_form.render()
    $('.skill-tags-form').append(@skill_list_tags_form.el)
    @interest_list_tags_form.render()
    $('.interest-tags-form').append(@interest_list_tags_form.el)
    @year_group_list_tags_form.render()
    $('.year-group-tags-form').append(@year_group_list_tags_form.el)

    $('.form').append(@form.el)
    @form.on "change", =>
      @form.validate()
    tiny_mce_init()
  @

  submitEmail: ->
    tiny_mce_save()
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Email Saved"
          Backbone.history.navigate('companies/' + @model.get('company_id') + '/emails', trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save email, please resolve issues below."
