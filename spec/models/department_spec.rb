require 'spec_helper'

describe Department do
  subject { FactoryGirl.build :department }

  it {should belong_to :organisation }

  it {should have_and_belong_to_many :companies}

  it {should have_many :students}

  context "when creating and saving" do
    fields = [:name, :organisation_id]

    fields.each do |field|
      it {should validate_presence_of field}
    end
  end

end
