require 'spec_helper'

describe Placement do
  include AttributeValidators
  subject { FactoryGirl.build :placement }

  it {should be_valid}

  it {should be_invalid_for_nil_field(:position)}

  it {should be_invalid_for_nil_field(:description)}

  it {should be_invalid_for_nil_field(:location)}

  it {should be_invalid_for_nil_field(:deadline)}

  it {should be_invalid_for_given_field(:deadline, Time.at(Time.now.to_i - 1.day.to_i))}

  it {should be_valid_for_given_field(:deadline, Time.at(Time.now.to_i + 1.day.to_i))}

end
