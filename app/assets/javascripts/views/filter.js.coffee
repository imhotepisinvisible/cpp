class CPP.Filter extends CPP.Views.Base
  template: JST['filters/filter']
  templateText: JST['filters/filter_text']
  templateTags: JST['filters/filter_tag']
  templateFilterHeader: JST['filters/filter_header']

  events:
    "keyup .fltr-search" : "setFilter"
    "blur .fltr-search" : "setFilter" 
    "click .fltr-tags" : "setFilter"

  sub_el: "#filters"

  initialize: (options) ->
    @filters = options.filters
    @data = options.data
    @render()

  render: ->
    $(@el).html(@template())
    for filter in @filters
      switch filter.type
        when "text"
          $(@sub_el).append(@templateFilterHeader(filter: filter))          
          $(@sub_el).append(@templateText(filter: filter))
        when "number"
          $(@sub_el).append(@templateFilterHeader(filter: filter)) 
          $(@sub_el).append(@templateText(filter: filter))
        when "tags"
          $(@sub_el).append(@templateFilterHeader(filter: filter))
          @renderTags(@getTagNames(filter))
  @

  renderTags: (tags) ->
    for t in tags
      $(@sub_el).append(@templateTags(tag: t))


  setFilter: () ->
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
            visTags = @getVisibleTags()
            fCollection = new CPP.Collections.Events(fCollection.filter((model) =>
              res = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
              res.toString() in visTags
            ))        
    @data.trigger('filter', fCollection)
  @

  getVisibleTags: ()->
    tags = []
    for tag in $('.fltr-tags')
      tags.push(tag.firstElementChild.innerText)
    tags

  getTagNames: (filter) ->
    tags = []
    @data.each (model) =>
      tag = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
      if ((tags.indexOf tag) == -1)
        tags.push tag
    tags
