require 'spec_helper'

describe Event do
  include AttributeValidators
  let(:event) { FactoryGirl.build :event }
  subject { event }

  it {should be_valid}

  context "when saving or creating a company" do
    fields = [:title, :description, :start_date, :end_date]

    fields.each do |field|
      it {should validate_presence_of(field)}
    end
  end

  context "when start_date is before the current time" do
    it {should be_invalid_for_given_field(:start_date, Time.now - 1.day)}
  end

  context "when end_date is before start date" do
    it {should_not allow_value(event.start_date - 1.day).
        for(:end_date)}

    it {should_not allow_value(event.start_date).
        for(:end_date)}
  end

  context "when the end_date is after the start_date" do
    it {should allow_value(event.start_date + 1.day).
        for(:end_date)}
  end

end
