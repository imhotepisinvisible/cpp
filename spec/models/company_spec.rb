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
    fields = [:name, :description, :logo]

    fields.each do |field|
      it { should be_invalid_for_nil_field(field) }
    end
  end
end
