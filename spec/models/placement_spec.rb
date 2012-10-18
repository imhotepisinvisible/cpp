require 'spec_helper'

describe Placement do
  include ValidateInvalidAttribute
  let(:placement) { FactoryGirl.build :placement }
  subject { placement }

  it {should be_valid}

  it {should be_invalid_for_nil_field(:position)}

  it {should be_invalid_for_nil_field(:description)}

  it {should be_invalid_for_nil_field(:location)}

  it {should be_invalid_for_nil_field(:deadline)}

  it {should be_invalid_for_given_field(:deadline, Time.at(Time.now.to_i - 1.day.to_i))}

# TODO: Matcher
  it "allows a deadline after the current date" do
    placement.deadline = Time.at(Time.now.to_i + 1.day.to_i)
    placement.should be_valid
  end

end
