require 'rails_helper'

describe Event do
  let(:event) { FactoryGirl.build :event }
  subject { event }

  it {should be_valid}

  it {should belong_to :company}

  context "when saving or creating a company" do
    fields = [:title, :description, :start_date, :end_date]

    fields.each do |field|
      it {should validate_presence_of(field)}
    end
  end

  context "when start_date is before the current time" do
    it {should_not allow_value(1.day.ago).
        for(:start_date)}
  end

  context "when end_date is before start date" do
    it {should_not allow_value(event.start_date - 1.day).
        for(:end_date)}

    it {should_not allow_value(event.start_date - 1.second).
        for(:end_date)}

    it {should_not allow_value(event.start_date).
        for(:end_date)}
  end

  context "when the end_date is after the start_date" do
    it {should allow_value(event.start_date + 1.day).
        for(:end_date)}

    it {should allow_value(event.start_date + 1.second).
        for(:end_date)}
  end

end
