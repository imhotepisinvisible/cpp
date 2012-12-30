# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :department_administrator, parent: :user, :class => "DepartmentAdministrator" do
    department
  end
end

