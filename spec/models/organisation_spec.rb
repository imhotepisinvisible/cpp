require 'spec_helper'

describe Organisation do
  subject { FactoryGirl.build(:organisation) }

  it {should be_valid}

  it {should validate_presence_of(:name)}

end
