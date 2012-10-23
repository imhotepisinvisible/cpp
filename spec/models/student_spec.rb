require 'spec_helper'

describe Student do

  it_should_behave_like "a user" do
    let(:user) { FactoryGirl.create :student }
  end

end
