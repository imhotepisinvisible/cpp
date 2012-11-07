class CPP.Filter extends CPP.Views.Base
  template: JST['filters/filter']
  templateText: JST['filters/filter_text']
  templateTags: JST['filters/filter_tag']

  events:
    "click .search-btn"         : "search"
    "click #fltr-search-close"  : "clearSearch"


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

  search: ->
    # Filter on all filters
    for filter in @filters
      switch filter.type
        when "text"
          @data.each (model) ->
            model.set "visible", false
            ma = model.get filter.attribute
            tb = $("#fltr-search").val()
            if ma.toString() == tb || $("#fltr-search").val() == ""
              model.set "visible", true
    @data.trigger('filter')

  clearSearch: ->
    $("#fltr-search").val("")
    @search()
