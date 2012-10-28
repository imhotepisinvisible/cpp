require 'spec_helper'

describe Student do

  it_should_behave_like "a user" do
    let(:unsaved) { FactoryGirl.build :student }
    let(:saved) { FactoryGirl.create :student }
  end

end
