require 'spec_helper'

describe StudentProfile do
  include AttributeValidators
  context "when validating any student profile" do
    subject { FactoryGirl.build(:student_profile,
                                   :beng_student,
                                   :first_year) }

    it {should be_valid}

    context "when attributes are not set" do
      fields = [:year, :bio, :degree]

      fields.each do |field|
        it {should be_invalid_for_nil_field(field)}
      end
    end
  end
end
