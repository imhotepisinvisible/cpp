CPP.Views.TaggedEmails ||= {}

class CPP.Views.TaggedEmails.Edit extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/emails/editval']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitEmail'

  initialize: ->
    @form = new Backbone.Form(model: @model).render()

    saveTagModel = =>
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          # notify "success", "Updated Profile TAG"
          @updateStats()
        error: (model, response) ->
          # Notify tag-specific errors here (profanity etc)
          errorlist = JSON.parse response.responseText
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
    @updateStats()
  @

  submitEmail: ->
    tiny_mce_save()
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Email Saved"
          Backbone.history.navigate('companies/' + @model.get('company_id') + '/tagged_emails', trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to save email, please resolve issues below."

  updateStats: ->
    $.get "/tagged_emails/" + @model.id + "/get_matching_students_count", (data) ->
      console.log jQuery.isEmptyObject(data)
      if !jQuery.isEmptyObject(data)
        totalRecipients = 0
        output = "<dl class=\"dl-horizontal\">\n"
        for year in Object.keys(data)
          totalRecipients += data[year]
          output += "<dt>Year "+year+"</dt><dd>"+data[year]+" student"
          if data[year] > 1
            output += "s"
          output += "</dd>\n"
        output += "<dt>Total</dt><dd>" + totalRecipients + " student"
        if totalRecipients > 1
          output += "s"
        output += "</dd></dl>\n"
      else
        output = "<h4 class=\"warning\">No students match these tags!</h4>"
      $('#email-stats').empty().append(output)
