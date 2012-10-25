module AttributeValidators
  class InvalidMatcher
    def initialize(attribute, value)
      @attribute = attribute
      @value = value
    end

    def matches?(model)
      @model = model
      model[@attribute] = @value
      model.invalid?
    end

    def failure_message_for_should
      "#{@model.errors.full_messages} was valid with #{@attribute}: #{@value}"
    end

    def failure_message_for_should_not
      "#{@model.errors.full_messages} was invalid with #{@attribute}: #{@value}"
    end

    def description
      "model should be invalid for attribute #{@attribute}"
    end
  end

  class ValidMatcher
    def initialize(attribute, value)
      @attribute = attribute
      @value = value
    end

    def matches?(model)
      @model = model
      model[@attribute] = @value
      model.valid?
    end

    def failure_message_for_should
      "#{@model.errors.full_messages} was invalid with #{@attribute}: #{@value}"
    end

    def failure_message_for_should_not
      "#{@model.errors.full_messages} was valid with #{@attribute}: #{@value}"
    end

    def description
      "model should be valid for attribute #{@attribute}"
    end
  end


  def be_invalid_for_nil_field(attribute)
    InvalidMatcher.new(attribute, nil)
  end

  def be_invalid_for_given_field(attribute, value)
    InvalidMatcher.new(attribute, value)
  end

  def be_valid_for_given_field(attribute, value)
    ValidMatcher.new(attribute, value)
  end
end
