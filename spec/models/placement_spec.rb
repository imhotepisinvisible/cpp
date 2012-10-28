require 'spec_helper'

describe Placement do
  include AttributeValidators
  subject { FactoryGirl.build :placement }

  it {should be_valid}

  context "when attributes are not set" do
    fields = [:position, :description, :location, :deadline]

    fields.each do |field|
      it {should be_invalid_for_nil_field(field)}
    end
  end

  context "when deadline is before the current date" do
    it {should be_invalid_for_given_field(:deadline, Time.at(Time.now.to_i - 1.day.to_i))}
  end

  context "when the deadline is after the current date" do
    it {should be_valid_for_given_field(:deadline, Time.at(Time.now.to_i + 1.day.to_i))}
  end

end
