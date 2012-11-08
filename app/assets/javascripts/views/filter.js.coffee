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
          $(@sub_el).append(@templateTags(filter: filter))
  @

  setFilter: ->
    fCollection = @data
    for filter in @filters 
      tb =  $("#"+filter.attribute).val()
      if (tb != "")
        # Update collection
        switch filter.type
          when "text"
            fCollection = new CPP.Collections.Events(fCollection.filter((model) ->
              ((model.get(filter.attribute).toString().indexOf tb) != -1)
            ))
          when "number"
            fCollection = new CPP.Collections.Events(fCollection.filter((model) ->
              model.get(filter.attribute).toString() is tb
            ))
    @data.trigger('filter', fCollection)

