require 'spec_helper'

describe User do
  it_should_behave_like "a user" do
    let(:unsaved) { FactoryGirl.build :user }
    let(:saved) { FactoryGirl.create :user }
  end
end
