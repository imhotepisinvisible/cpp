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
    "blur .tag-input"           : "blurTag"
    "change .fltr-date"         : "setFilter"

  sub_el: "#filters"

  initialize: (options) ->
    @filters = options.filters
    @data = options.data
    @model = new CPP.Models.Event
    # Set tag lists to be empty
    @model.set("skill_list",[])
    @model.set("interest_list",[])
    @model.set("year_group_list",[])
    @model.bind 'change', @setFilter, @
    # Re-set filter after deletion
    @data.bind 'remove', @setFilter, @

    @skill_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'skill_list'
      title: 'Skills'
      url: '/tags/skills'
      tag_class: 'label-success'

    @interest_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'interest_list'
      title: 'Interests'
      url: '/tags/interests'
      tag_class: 'label-warning'

    @year_group_list_tags_form = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'year_group_list'
      title: 'Year Groups'
      url: '/tags/year_groups'
      tag_class: 'label-info'

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

  blurTag: (e) ->
    deferreds = []
    if $(e.currentTarget).parent().find('.dropdown-menu').is(':visible') and
       $(e.currentTarget).parent().find('.dropdown-menu:hover').length > 0
      deferreds.push($(e.currentTarget).parent().find('.dropdown-menu').click())

    $.when.apply($, deferreds).done (=>
      @setFilter()
    )

  # Applies filters, filtering from the collection accordingly  
  setFilter: ->
    fCollection = @data
    if @filters
      for filter in @filters
        textBox =  $("#"+filter.attribute).val()
        switch filter.type
         # For different filter types filter the collection appropriately
          when "text"
            # Dont filter when nothing in text box
            if (textBox != "")
              # Filter from collection if filter text is not a substring 
              fCollection = new (fCollection.constructor)(fCollection.filter((model) ->
                res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
                (res.toString().toLowerCase().indexOf tb.toLowerCase()) != -1
              ))
          when "number"
            if (textBox != "")
              # Filter from collection if filter number is not present
              fCollection = new (fCollection.constructor)(fCollection.filter((model) ->
                res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
                res.toString() is textBox
              ))
          when "tags"
            # For each tag set, filter out data that does not correspond to all tags
            for tagFilter in filter.attribute
              filterTags = @model.get(tagFilter)
              # Only filter when tags added to filter
              if filterTags.length > 0
                fCollection = new (fCollection.constructor)(fCollection.filter((model) =>
                  modelTags = eval('with (model,filter,tagFilter) {model' + filter.scope + '.get(tagFilter)}')
                  ret = true;
                  for tag in filterTags
                    ret &= tag in modelTags
                  ret
                ))
          when "date"
            fCollection = new (fCollection.constructor)(fCollection.filter((model) ->
              res = eval('with (model, filter) {model' + filter.scope + '.get(filter.attribute)}')
              res >= tb || res == null
            ))
      # Trigger filter with the updated collection to re-render individually from the page
      @data.trigger('filter', fCollection)
  @

