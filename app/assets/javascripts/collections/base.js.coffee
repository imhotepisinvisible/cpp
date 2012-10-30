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
