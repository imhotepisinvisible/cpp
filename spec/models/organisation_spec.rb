require 'spec_helper'

describe Organisation do
  include AttributeValidators
  subject { FactoryGirl.build :organisation }

  it {should be_valid}

  context "when attributes are not set" do
    it {should be_invalid_for_nil_field(:name)}
  end

end
