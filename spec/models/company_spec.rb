require 'spec_helper'

describe Company do
  include AttributeValidators
  let(:company) { FactoryGirl.build :company }
  subject { company }

  context "when attributes are set" do
    it { should be_valid }
    its(:description) { should have_at_most(500).items }
  end

  context "when attributes are not set" do
    it { should be_invalid_for_nil_field(:name) }
    it { should be_invalid_for_nil_field(:description) }
  end

end
