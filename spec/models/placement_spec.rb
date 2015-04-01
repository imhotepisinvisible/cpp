require 'rails_helper'

describe Placement do
  subject { FactoryGirl.build :placement }

  it {should be_valid}

  it {should belong_to :company}

  context "when creating or saving a student" do
    fields = [:position, :description, :location]

    fields.each do |field|
      it {should validate_presence_of(field)}
    end
  end

  context "when deadline is before the current date" do
    it {should_not allow_value(1.day.ago).
        for(:deadline)}
  end

  context "when the deadline is after the current date" do
    it {should allow_value(1.day.from_now).
        for(:deadline)}
  end

  context "when interview_date is before the current date" do
    it {should_not allow_value(1.day.ago).
        for(:interview_date)}
  end

end
