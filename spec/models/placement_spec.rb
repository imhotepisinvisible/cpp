require 'spec_helper'

describe Placement do
  before(:each) do
    @placement = FactoryGirl.create :placement
  end

  it "has a valid factory" do
    @company.should be_valid
  end
  
  it "requires a position" do
    @placement.position = ""
    @placement.should be_invalid
  end

  it "requires a description" do
    @placement.description = ""
    assert @placement.should be_invalid
  end

  it "requires a duration" do
    @placement.duration = ""
    @placement.should be_invalid
  end

  it "requires a location" do
    @placement.location = ""
    @placement.should be_invalid
  end

  it "requires a deadline" do
    @placement.deadline = ""
    assert @placement.should be_invalid
  end

  it "requires that a description contains less than 80 words" do
    @placement.description = "word " * 79
    @placement.should be_valid

    @placement.description = "word " * 80
    @placement.should be_valid

    @placement.description = "word " * 81
    @placement.should be_invalid
  end

end
