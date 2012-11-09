class CPP.Filter extends CPP.Views.Base
  template: JST['filters/filter']
  templateText: JST['filters/filter_text']
  templateTags: JST['filters/filter_tag']

  events:
    "keyup .fltr-search" : "setFilter"
    "blur .fltr-search" : "setFilter"

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
          $(@sub_el).append(@templateText(filter: filter))
        when "number"
          $(@sub_el).append(@templateText(filter: filter))
        when "tags"
          $(@sub_el).append(@templateTags(filter: filter ))
  @

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
            #console.log "tags", (@getTagNames(filter))
    @data.trigger('filter', fCollection)
  @

  getTagNames: (filter) ->
    tags = []
    @data.each (model) =>
      console.log filter
      console.log model
      tag = eval('with (model,filter) {model' + filter.scope + '.get(filter.attribute)}')
      console.log tag
      if ((tags.indexOf tag) == -1)
        tags.push tag
    tags
