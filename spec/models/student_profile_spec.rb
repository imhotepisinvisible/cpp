require 'spec_helper'

describe StudentProfile do
  context "when validating any student profile" do
    subject { FactoryGirl.build(:student_profile,
                                   :beng_student,
                                   :first_year) }

    it {should be_valid}

    it {should belong_to :student}

    context "when creating or saving" do
      fields = [:year, :bio, :degree]

      fields.each do |field|
        it {should validate_presence_of(field)}
      end
    end
  end
end
