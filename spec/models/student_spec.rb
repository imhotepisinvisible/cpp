require 'spec_helper'

describe Student do
  subject { FactoryGirl.build :student }

  it_should_behave_like "a user" do
    let(:unsaved) { FactoryGirl.build :student }
    let(:saved) { FactoryGirl.create :student }
  end

  it "should have a valid email domain" do
    org = subject.department.organisation
    org.organisation_domains.each do |domain|
      it {should be_valid_for_given_field(:email, "student@" + domain)}
    end
  end

end
