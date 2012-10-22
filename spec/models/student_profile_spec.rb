require 'spec_helper'

describe StudentProfile do
  include AttributeValidators
  context "when validating any student" do
    subject { FactoryGirl.build(:student_profile,
                                   :beng_student,
                                   :first_year) }
    it {should be_valid}

    context "when attributes are not set" do
      it {should be_invalid_for_nil_field(:year)}

      it {should be_invalid_for_nil_field(:bio)}

      it {should be_invalid_for_nil_field(:degree)}
    end
  end

  context "when BEng student" do
    subject { FactoryGirl.build(:student_profile,
                                   :beng_student)}

    it {should be_valid_for_given_field(:year, "1")}
    it {should be_valid_for_given_field(:year, "2")}
    it {should be_valid_for_given_field(:year, "3")}
    it {should be_invalid_for_given_field(:year, "4")}
  end

end
