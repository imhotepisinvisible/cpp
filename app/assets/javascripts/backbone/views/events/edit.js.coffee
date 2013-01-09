CPP.Views.Events ||= {}

class CPP.Views.Events.Edit extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/events/editval']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitEvent'

  # Department admins don't get to select departments
  # Companies get to pick which departments their events will go to
  initialize: ->
    @model.set "requirementsEnabled", false

    if isDepartmentAdmin()
      companies = new CPP.Collections.Companies
      companies.url = "/departments/#{CPP.CurrentUser.get('department_id')}/companies"

      schema = @model.schema()
      if @model.isNew()
        # On creation of an event, admin can choose company
        schema['company_id'] = {
          text: "Company"
          type: "Select"
          title: "Company"
          options: companies
          editorClass: "company-select"
        }

        # Only set departments if we are creating a new event
        @model.set('departments', [CPP.CurrentUser.get('department_id')])

      # Department doesn't get to see departments
      delete schema["departments"]
      @model.schema = -> schema

    @completeInitialize()

  completeInitialize: ->
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

    @year_group_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'year_group_list'
      title: 'Year Groups'
      url: '/tags/year_groups'
      tag_class: 'label-info'
      additions: true

    @render()


  render: ->
    $(@el).html(@template(event: @model))
    super
    $('.form').append(@form.render().el)

    # Initial check for rendering requirements box
    if @model.get("requirements")
      @model.set "requirementsEnabled", true
      $(".requirements-checkbox").children()[0].children[0].checked = true;
      @form.fields["requirements"].$el.slideDown()

    validateField(@form, field) for field of @form.fields

    @form.on "requirementsEnabled:change", =>
      @form.fields["requirements"].$el.slideToggle()

    @skill_list_tags_form.render()
    @interest_list_tags_form.render()
    @year_group_list_tags_form.render()
    $('.skill-tags-form').append(@skill_list_tags_form.el)
    $('.interest-tags-form').append(@interest_list_tags_form.el)
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
