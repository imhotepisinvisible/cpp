# Audit items are used in the department administrator stats and
# show a timeline of relevant events in the CPP application's history
class AuditItem
  attr_accessor :model, :timestamp, :type, :message, :url

  # model - the associated model
  # timestamp - the timestamp for when the event occurred
  # type - used on the front end to alter the visual appearance
  # message - brief summary of item/change
  # url - if the item could link to another page, put the url here
  def initialize(model, timestamp, type = "unknown", message = "", url = nil)
    @model = model
    @timestamp = timestamp
    @type = type
    @message = message
    @url = url
    puts self.inspect
  end

  def as_json(options = {})
    return {
      timestamp: @timestamp,
      type: @type,
      message: @message,
      url: @url
    }
  end
end
