require 'spec_helper'

describe Company do
  let(:company) { FactoryGirl.build :company }
  subject { company }

  it { should be_valid }

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
