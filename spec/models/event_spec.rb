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

  it "requires a start date" do
    @event.start_date = nil
    assert @event.should be_invalid
  end

  it "requires a date" do
    @event.start_date = nil
    assert @event.should be_invalid
  end

  it "requires a description" do
    @event.description = ""
    assert @event.should be_invalid
  end

  it "requires a location" do
    @event.description = ""
    assert @event.should be_invalid
  end

end
