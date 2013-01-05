class CPP.Filter extends CPP.Views.Base
  template: JST['backbone/templates/filters/filter']
  templateText: JST['backbone/templates/filters/filter_text']
  templateTags: JST['backbone/templates/filters/filter_tag']
  templateDate: JST['backbone/templates/filters/filter_date']
  templateFilterHeaderText: JST['backbone/templates/filters/filter_header_text']
  templateFilterHeaderTag: JST['backbone/templates/filters/filter_header_tag']
  templateFilterHeaderDate: JST['backbone/templates/filters/filter_header_date']

  events: -> _.extend {}, CPP.Views.Base::events,
    "keyup .fltr-search"        : "setFilter"
    "blur .tag-input"           : "setFilter"
    'change .fltr-date'         : "setFilter"

  sub_el: "#filters"

  initialize: (options) ->
    @filters = options.filters
    @data = options.data
    @model = new CPP.Models.Event
    @model.set("skill_list",[])
    @model.set("interest_list",[])
    @model.set("year_group_list",[])
    @model.bind 'change', @setFilter, @

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
    $(@el).html(@template())
    for filter in @filters
      switch filter.type
        when "text"
          $(@sub_el).append(@templateFilterHeaderText(filter: filter))
          $(@sub_el).append(@templateText(filter: filter))
        when "number"
          $(@sub_el).append(@templateFilterHeaderText(filter: filter))
          $(@sub_el).append(@templateText(filter: filter))
        when "tags"
          $(@sub_el).append(@templateFilterHeaderTag(filter: filter))
          @renderTags()
        when "date"
          $(@sub_el).append(@templateFilterHeaderDate(filter: filter))
          $(@sub_el).append(@templateDate(filter: filter))
          $('.fltr-date').datepicker
            weekStart: 1
            format: 'yyyy-mm-dd'
            autoclose: true
      if filter.default
        $('#'+filter.attribute).val(filter.default)
        @setFilter()
    @

  renderTags: ->
    @skill_list_tags_form.render()
    $('.skill-tags-form').append(@skill_list_tags_form.el)
    @interest_list_tags_form.render()
    $('.interest-tags-form').append(@interest_list_tags_form.el)
    @year_group_list_tags_form.render()
    $('.year-group-tags-form').append(@year_group_list_tags_form.el)


  setFilter: ->
    fCollection = @data
    if filters
      for filter in @filters
        tb =  $("#"+filter.attribute).val()
        switch filter.type
          when "text"
            # Dont filter when nothing in text box
            if (tb != "")
              fCollection = new (fCollection.constructor)(fCollection.filter((model) ->
                res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
                (res.toString().toLowerCase().indexOf tb.toLowerCase()) != -1
              ))
          when "number"
            if (tb != "")
              fCollection = new (fCollection.constructor)(fCollection.filter((model) ->
                res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
                res.toString() is tb
              ))
          when "tags"
            ftags = @model.get("skill_list").concat(@model.get("interest_list"))
            if ftags.length > 0
              fCollection = new (fCollection.constructor)(fCollection.filter((model) =>
                res = model.get("skill_list").concat(model.get("interest_list"))
                ret = false;
                for tag in ftags
                  ret |= tag in res
                ret
              ))
            # Filter year groups after to only include specified year
            yearTags = @model.get("year_group_list")
            if yearTags.length > 0
              fCollection = new (fCollection.constructor)(fCollection.filter((model) =>
                  res = model.get("year_group_list")
                  ret = false;
                  for tag in yearTags
                    ret |= tag in res
                  ret
                ))
          when 'date'
            fCollection = new (fCollection.constructor)(fCollection.filter((model) ->
              res = eval('with (model, filter) {model' + filter.scope + '.get(filter.attribute)}')
              res >= tb
            ))

      @data.trigger('filter', fCollection)
  @

