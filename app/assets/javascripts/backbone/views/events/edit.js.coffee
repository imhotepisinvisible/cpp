CPP.Views.Events ||= {}

class CPP.Views.Events.Edit extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/events/editval']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitEvent'

  initialize: ->
    @model.set "requirementsEnabled", false
    @form = new Backbone.Form(model: @model).render()
    Backbone.Validation.bind @form;

    saveTagModel = =>
      @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Updated Profile TAG"
        error: (model, response) =>
          # Notify tag-specific errors here (profanity etc)
          # errorlist = JSON.parse response.responseText
          notify "error", "Couldn't Update Tags"

    @skill_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'skill_list'
      title: 'Skills'
      url: '/tags/skills'
      tag_class: 'label-success'
      tag_change_callback: saveTagModel
      additions: true

    @interest_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'interest_list'
      title: 'Interests'
      url: '/tags/interests'
      tag_class: 'label-warning'
      tag_change_callback: saveTagModel
      additions: true

    @year_group_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'year_group_list'
      title: 'Year Groups'
      url: '/tags/year_groups'
      tag_class: 'label-info'
      tag_change_callback: saveTagModel
      additions: true

    @render()

  render: ->
    $(@el).html(@template(event: @model))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('.form').append(@form.el)
    # Initial check for rendering requirementes box
    if (((@model.get "requirements") != null) and
        ((@model.get "requirements") != ""))
      @model.set "requirementsEnabled", true
      # Tick Checkbox
      $(".requirements-checkbox").children()[0].children[0].checked = true;
      @form.fields["requirements"].$el.slideDown()
    @form.on "change", =>
      @form.validate()
    @form.on "requirementsEnabled:change", =>
      @form.fields["requirements"].$el.slideToggle()
    @skill_list_tags_form.render()
    $('.skill-tags-form').append(@skill_list_tags_form.el)
    @interest_list_tags_form.render()
    $('.interest-tags-form').append(@interest_list_tags_form.el)
    @year_group_list_tags_form.render()
    $('.year-group-tags-form').append(@year_group_list_tags_form.el)
  @

  submitEvent: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Event Saved"
          Backbone.history.navigate('companies/' + @model.get('company_id') + '/events', trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save event, please resolve issues below."
