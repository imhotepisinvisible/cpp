require 'spec_helper'

describe Company do
  let(:company) { FactoryGirl.build :company }
  subject { company }

  it { should be_valid }

  many = [:events, :placements]
  many.each do |association|
    it {should have_many association}
  end

  it {should belong_to :organisation}
  it {should have_and_belong_to_many :departments}

  context "when saving or creating a company" do
    fields = [:name, :description, :logo]

    fields.each do |field|
      it { should validate_presence_of(field) }
    end

    it { should ensure_length_of(:description).
         is_at_most(500).
         with_message("Description must have at most %{count} characters")
    }
  end
end
