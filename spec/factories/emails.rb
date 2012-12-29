# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email do
    company
    subject "Subject"
    body "Body"
    state "Rejected"
    # state {['Rejected', 'Pending', 'Approved', 'Postponed'].sample}
    created {FactoryHelper.time_rand(Time.now)}
    sent {FactoryHelper.time_rand(Time.now)}
  end
end
