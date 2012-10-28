require 'spec_helper'

describe OrganisationDomain do
  include AttributeValidators
  subject { FactoryGirl.build :organisation_domain }

  it {should be_valid}

  context "when attributes are not set" do
    fields = [:domain, :organisation_id]

    fields.each do |field|
      it { should be_invalid_for_nil_field(field) }
    end
  end
end
