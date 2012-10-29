require 'spec_helper'

describe Email do
  subject { FactoryGirl.build :email }

  it { should be_valid }

  it { should belong_to :company }
  it { should validate_presence_of :company_id }

  context "when creating or saving" do
    it { should validate_presence_of :subject }
    it { should validate_presence_of :body }
  end

end
