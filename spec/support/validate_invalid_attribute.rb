module ValidateInvalidAttribute
  class Matcher
    def initialize(attribute, value)
      @attribute = attribute
      @value = value
    end

    def matches?(model)
      valid = model.valid?
      model[@attribute] = @value
      valid and model.invalid?
    end

    def failure_message_for_should
      "blah"
    end

    def failure_message_for_should_not
      "blah blah"
    end
  end

  def be_invalid_for_nil_field(attribute)
    Matcher.new(attribute, nil)
  end

  def be_invalid_for_given_field(attribute, value)
    Matcher.new(attribute, value)
  end
end
