require 'spec_helper'

describe Company do
  let(:company) { FactoryGirl.build :company }
  subject { company }

  it { should be_valid }

  many = [:events, :placements, :emails]
  many.each do |association|
    it {should have_many association}
  end

  context "when saving or creating a company" do
    fields = [:name, :description]

    fields.each do |field|
      it { should validate_presence_of(field) }
    end

    it { should validate_length_of(:description).
         is_at_most(2000).
         with_message("is too long (maximum is 2000 characters)")
    }
  end
end
