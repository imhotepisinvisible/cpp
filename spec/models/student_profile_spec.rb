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

# TODO: How to check they can't enter a year above 4?
  context "when assigning students with a year" do
    full_range = 1..4

    {:beng_student => 1..3,
     :meng_student => full_range,
     :phd_student  => full_range,
     :msc_student  => 1..1
    }.each do |degree, range|
      student = FactoryGirl.build(:student_profile, degree)
      range.each do |year|
        it "#{degree} should be valid with year #{year}" do
         student.should be_valid_for_given_field(:year, year)
        end
      end
      (full_range.to_a - range.to_a).each do |year|
        it "#{degree} should not be valid with year #{year}" do
          student.should be_invalid_for_given_field(:year, year)
        end
      end
    end
  end
end
