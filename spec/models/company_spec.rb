require 'spec_helper'

describe Company do
  before(:each) do
    @company = FactoryGirl.create :company
  end

  it "has a valid factory" do
    @company.should be_valid
  end
  
  it "requires a name" do
    @company.name = ""
    @company.should be_invalid
  end

  it "requires a description" do
    @company.description = ""
    assert @company.should be_invalid
  end

  it "requires that a description contains less than 80 words" do
    @company.description = "word " * 79
    @company.should be_valid

    @company.description = "word " * 80
    @company.should be_valid

    @company.description = "word " * 81
    @company.should be_invalid
  end
end
