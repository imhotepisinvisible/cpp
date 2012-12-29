require 'spec_helper'

describe Email do
  subject { FactoryGirl.build :email }

  it { should be_valid }

  it { should belong_to :company }

  context "when creating or saving" do
    fields = [:subject, :body, :company_id, :state]
    fields.each do |field|
      it { should validate_presence_of field }
    end
    
    it { should ensure_inclusion_of(:state).in_array(
      ["Rejected", "Pending", "Approved", "Postponed"]
    )}
  end

end
