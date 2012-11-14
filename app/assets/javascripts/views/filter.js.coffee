class CPP.Filter extends CPP.Views.Base
  template: JST['filters/filter']
  templateText: JST['filters/filter_text']
  templateTags: JST['filters/filter_tag']
  templateFilterHeaderText: JST['filters/filter_header_text']
  templateFilterHeaderTag: JST['filters/filter_header_tag']

  events:
    "keyup .fltr-search" : "setFilter"
    "blur .fltr-search" : "setFilter" 
    "click .fltr-tags" : "setFilter"
    "click #tag-close" : "removeTag"
    "click #tag-label-text" : "removeTag"

  sub_el: "#filters"

  @tags = []

  initialize: (options) ->
    console.log "init"
    @filters = options.filters
    @data = options.data
    @render()

  render: ->
    console.log "ren"
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
          console.log "tags", @tags
          @renderTags()
  @

  renderTags: ->
    for t in @tags
      $(@sub_el).append(@templateTags(tag: t))


  setFilter: ->
    fCollection = @data
    for filter in @filters 
      tb =  $("#"+filter.attribute).val()
      # Dont filter when nothing in text box
      if (tb != "")
        # Update collection
        switch filter.type
          when "text"
            fCollection = new CPP.Collections.Events(fCollection.filter((model) ->
              res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
              (res.toString().indexOf tb) != -1
            ))
          when "number"
            fCollection = new CPP.Collections.Events(fCollection.filter((model) ->
              res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
              res.toString() is tb
            ))
          when "tags"
            fCollection = new CPP.Collections.Events(fCollection.filter((model) =>
              res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
              res.toString() in @tags
            ))        
    @data.trigger('filter', fCollection, true)
  @

  removeTag: (e) =>
    @tags = @tags.filter((tag) =>
      tag isnt ($(e.target).prev().html())
    )
    @setFilter()

  getTagNames: (filter) ->
    tags = []
    @data.each (model) =>
      tag = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
      if ((tags.indexOf tag) == -1)
        tags.push tag
    @tags = tags
