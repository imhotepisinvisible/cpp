require 'spec_helper'

describe Organisation do
  subject { FactoryGirl.build(:organisation) }

  it {should be_valid}

  many = [:companies, :organisation_domains, :departments]
  many.each do |attribute|
    it {should have_many attribute}
  end

  it {should validate_presence_of(:name)}

end
