require 'spec_helper'

describe Event do
  before(:each) do
    @event = FactoryGirl.create :event
  end

  it "has a valid factory" do
    @event.should be_valid
  end

  it "requires a title" do
    @event.title = ""
    @event.should be_invalid
  end


  it "requires a description" do
    @event.description = ""
    assert @event.should be_invalid
  end

  it "requires a location" do
    @event.description = ""
    assert @event.should be_invalid
  end


  it "requires a start_date" do
    @event.start_date = nil
    assert @event.should be_invalid
  end

  it "requires the start date be after the current time" do
    @event.start_date = Time.now - 1.day
    assert @event.should be_invalid
  end

  it "requires an end_date" do
    @event.end_date = nil
    assert @event.should be_invalid
  end

  it "requires the end_date should be after the start_date" do
    @event.end_date = @event.start_date - 1.day
    assert @event.should be_invalid

    @event.end_date = @event.start_date
    assert @event.should be_invalid

    @event.end_date = @event.start_date + 1.day
    assert @event.should be_valid
  end


end
