FactoryGirl.define do
  factory :company_contact do
    company
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "#{first_name}_#{last_name}@#{company.name.downcase.delete('^a-z ').gsub(' ', '_')}.co.uk"}
    role { ["HR", "Developer", "Recruiter"].sample }
  end
end

