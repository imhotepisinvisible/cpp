require 'rails_helper'

describe Department do
  subject { FactoryGirl.build :department }

  it {should have_many :students}

  context "when creating and saving" do
    fields = [:name]

    fields.each do |field|
      it {should validate_presence_of field}
    end
  end

end
