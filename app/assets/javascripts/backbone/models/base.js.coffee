class CPP.Models.Base extends Backbone.Model
  record_stat_view: ->
    console.log "STAT"
    console.log @url
    console.log @url()
    return unless @url?
    console.log @url() + "/stat_show"

    $.get(@url() + "/stat_show")

class CPP.Collections.Base extends Backbone.Collection

  # Search through the models in the collection
  # e.g.
  #  events = new CPP.Collections.Events
  #  events.fetch()
  #  ...
  #  googleEvents = events.search({ title: "Google Talk" })
  #
  # TODO: Improve to use Regex, not string match
  search: (opts) ->
    result = this.where opts
    resultCollection = new CPP.Collections.Events results
    return resultCollection
