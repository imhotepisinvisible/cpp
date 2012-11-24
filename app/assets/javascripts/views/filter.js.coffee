class CPP.Filter extends CPP.Views.Base
  template: JST['filters/filter']
  templateText: JST['filters/filter_text']
  templateTags: JST['filters/filter_tag']
  templateFilterHeaderText: JST['filters/filter_header_text']
  templateFilterHeaderTag: JST['filters/filter_header_tag']

  events: -> _.extend {}, CPP.Views.Base::events,
    "keyup .fltr-search"    : "setFilter"
    "click .fltr-tags"      : "setFilter"
    "click #tag-close"      : "removeTag"
    "click #tag-label-text" : "removeTag"
    "click #add-tag"        : "addTag"

  sub_el: "#filters"

  @tags = []

  initialize: (options) ->
    @filters = options.filters
    @data = options.data
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
          @getTagNames(filter)
          @renderTags()
  @

  renderTags: ->
    for t in @tags
      $(@sub_el).append(@templateTags(tag: t))


  setFilter: ->
    fCollection = @data
    # find type of collection
    for filter in @filters 
      tb =  $("#"+filter.attribute).val()
      # Dont filter when nothing in text box
      if (tb != "")
        # Update collection
        switch filter.type
          when "text"
            fCollection = new (fCollection.constructor)(fCollection.filter((model) ->
              res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
              (res.toString().toLowerCase().indexOf tb.toLowerCase()) != -1
            ))
          when "number"
            fCollection = new (fCollection.constructor)(fCollection.filter((model) ->
              res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
              res.toString() is tb
            ))
          when "tags"
            fCollection = new (fCollection.constructor)(fCollection.filter((model) =>
              res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
              res.toString() in @tags
            ))    
    @data.trigger('filter', fCollection)
  @

  removeTag: (e) =>
    @tags = @tags.filter((tag) =>
      tag isnt $(e.target).prev().html()
    )
    @setFilter()

  addTag: (e) ->
    tag = $(e.target).prev().val()
    @tags.push tag
    # Need tag module to generate a tag


  getTagNames: (filter) ->
    tags = []
    @data.each (model) =>
      tag = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
      if ((tags.indexOf tag) == -1)
        tags.push tag
    @tags = tags
