require 'spec_helper'

describe Placement do
  before(:each) do
    @placement = FactoryGirl.create :placement
  end

  it "has a valid factory" do
    @placement.should be_valid
  end

  it "requires a position" do
    @placement.position = ""
    @placement.should be_invalid
  end

  it "requires a description" do
    @placement.description = ""
    assert @placement.should be_invalid
  end

  it "requires a location" do
    @placement.location = ""
    @placement.should be_invalid
  end

  it "requires a deadline" do
    @placement.deadline = ""
    assert @placement.should be_invalid
  end

end
