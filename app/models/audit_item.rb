class AuditItem
  attr_accessor :model, :timestamp, :type, :message, :url

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
