class AuditItem

  attr_accessor :model, :timestamp, :type, :message, :url

  def between_dates(start_date = 7.days.ago, end_date = Date.today)
  end

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
