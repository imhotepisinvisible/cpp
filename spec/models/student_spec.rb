require 'rails_helper'

describe Student do
  subject { FactoryGirl.build :student }

  it "should not be valid for invalid email address" do
    subject.email = "student@blahblahblah.com"
    subject.should_not be_valid
  end

  it_should_behave_like "a user" do
    let(:unsaved) { FactoryGirl.build :student }
    let(:saved) { FactoryGirl.create :student }
  end

  it "should have a valid email domain" do
    OrganisationDomain.all.each do |org_domain|
        subject.email = "student@" + org_domain.domain
        subject.should be_valid
        # subject.should allow_value(:email, "student@" + org_domain.domain)
    end
  end

  it "should have default looking_for" do
    s = Student.new
    s.looking_for.should eq("Not looking for anything")
  end

end
