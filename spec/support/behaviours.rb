shared_examples_for "a user" do

  context "for an existing user" do
    subject{ saved }
    it { should be_valid }

    it {should respond_to(:password_digest)}

    it {should validate_presence_of(:password_digest)}

    it {should respond_to(:authenticate)}
  end

  context "for a new user" do
    subject{ unsaved }

    fields = [:email, :first_name, :last_name]
    fields.each do |field|
      it {should validate_presence_of(field)}
    end

    it { should validate_length_of(:password).
      is_at_least(8).
      with_message(/password is too short/)
    }
  end

end
