class CPP.Filter extends CPP.Views.Base
  template: JST['filters/filter']
  templateText: JST['filters/filter_text']
  templateTags: JST['filters/filter_tag']


  sub_el: "#filters"

  initialize: (options) ->
    @filters = options.filters
    @data = options.data
    @render()

  render: ->
    console.log @filters
    $(@el).html(@template())
    for filter in @filters
      switch filter.type
        when "text"
          console.log "yer"
          $(@sub_el).append(@templateText())
        when "tags"
          console.log "tags"
          $(@sub_el).append(@templateTags())
  @