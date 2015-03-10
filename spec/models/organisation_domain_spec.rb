require 'spec_helper'

describe OrganisationDomain do
  subject { FactoryGirl.build :organisation_domain }

  it {should be_valid}

  context "when creating or saving" do
    fields = [:domain]

    fields.each do |field|
      it { should validate_presence_of(field) }
    end
  end
end
