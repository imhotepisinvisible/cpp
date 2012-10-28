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

  context "when assigning an unknown degree" do
    subject {FactoryGirl.build(:student_profile, :first_year, degree: "degree")}
    it {should be_invalid}
  end

  context "when assigning an invalid year year" do
    student_profile = FactoryGirl.build(:student_profile, :beng_student, year: 5)
    it {should be_invalid}
  end

  context "when assigning students with a year" do
    full_range = 1..4

    {:beng_student => 1..3,
     :meng_student => full_range,
     :phd_student  => full_range,
     :msc_student  => 1..1
    }.each do |degree, range|
      student_profile = FactoryGirl.build(:student_profile, degree)
      range.each do |year|
        it "#{degree} should be valid with year #{year}" do
         student_profile.should be_valid_for_given_field(:year, year)
        end
      end
      (full_range.to_a - range.to_a).each do |year|
        it "#{degree} should not be valid with year #{year}" do
          student_profile.should be_invalid_for_given_field(:year, year)
        end
      end
    end
  end
end
