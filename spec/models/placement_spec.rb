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
    @placement.deadline = nil
    assert @placement.should be_invalid
  end

  it "does not allow a deadline before the current date" do
    @placement.deadline = Time.at(Time.now.to_i - 1.day.to_i)
    assert @placement.should be_invalid
  end

  it "allows a deadline after the current date" do
    @placement.deadline = Time.at(Time.now.to_i + 1.day.to_i)
    assert @placement.should be_valid
  end

end
