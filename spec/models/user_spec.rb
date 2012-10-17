require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.build :user
  end

  it "has a valid factory" do
    @user.should be_valid
  end

  it "user model has secure password" do 
    @user.should respond_to(:password_digest)
    @user.should respond_to(:authenticate)
  end

  it "requires an email address" do
    @user.email = ""
    @user.should be_invalid
  end

  it "requires a password digest" do
    @user.password_digest = ""
    @user.should be_invalid
  end
end
