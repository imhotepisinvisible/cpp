require 'spec_helper'

describe StudentProfile do
  context "when validating any student profile" do
    subject { FactoryGirl.build(:student_profile,
                                   :beng_student,
                                   :first_year) }

    it {should be_valid}

    it {should belong_to :student}

    context "when creating or saving" do
      fields = [:year, :bio, :degree, :student_id]

      fields.each do |field|
        it {should validate_presence_of(field)}
      end

      it { should ensure_length_of(:bio).
         is_at_most(500).
         with_message("Bio must have at most 500 characters")
      }
    end
  end
end
