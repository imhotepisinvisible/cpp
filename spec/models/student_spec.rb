require 'spec_helper'

describe Student do
  subject { FactoryGirl.build :student }

  it {should belong_to :department}

  it "should not be valid for invalid email address" do
    subject.email = "student@blahblahblah.com"
    subject.should_not be_valid
  end

  it_should_behave_like "a user" do
    let(:unsaved) { FactoryGirl.build :student }
    let(:saved) { FactoryGirl.create :student }
  end

  it "should have a valid email domain" do
    puts subject.department.organisation.organisation_domains.inspect
    org = subject.department.organisation
      org.organisation_domains.each do |org_domain|
        subject.email = "student@" + org_domain.domain
        subject.should be_valid
        # subject.should allow_value(:email, "student@" + org_domain.domain)
    end
 end


end
