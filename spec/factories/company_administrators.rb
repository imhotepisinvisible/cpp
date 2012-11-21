# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company_administrator, parent: :user, :class => "CompanyAdministrator" do
    company
  end
end

