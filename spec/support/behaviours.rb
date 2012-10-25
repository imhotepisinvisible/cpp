shared_examples_for "a user" do
  include AttributeValidators

  context "for an existing user" do
    subject{ user }

    it { should be_valid }

    it {should respond_to(:password_digest)}

    it {should respond_to(:authenticate)}
  end

  context "for a new user" do
    subject{ FactoryGirl.build :user }

    it {should be_invalid_for_nil_field(:email)}

    its(:password) { should have_at_least(8).items }
  end

end
