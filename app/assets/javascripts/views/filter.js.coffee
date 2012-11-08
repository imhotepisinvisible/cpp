class CPP.Filter extends CPP.Views.Base
  template: JST['filters/filter']
  templateText: JST['filters/filter_text']
  templateTags: JST['filters/filter_tag']

  events:
    "click .search-btn"         : "setFilter"
    "click #fltr-search-close"  : "unsetFilter"


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
        when "tags"
          $(@sub_el).append(@templateTags(filter: filter))
  @

  setFilter: ->
    for filter in @filters
      fa = filter.attribute
      console.log fa
      tb =  $("#"+fa).val()
      console.log tb
      console.log tb
      fCollection = @data
      if (tb != "")
        # Update collection
        fCollection = new CPP.Collections.Events(@data.filter((model) ->
          model.get(filter.attribute).toString() is tb 
        ))
    @data.trigger('filter', fCollection)

  unsetFilter: ->
    $("#capacity").val("")
    @setFilter()
