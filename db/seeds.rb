require 'factory_girl'
require Rails.root.join("spec/support/factory_helper.rb")
Dir[Rails.root.join("spec/factories/*.rb")].each {|f| require f}

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

organisation = FactoryGirl.create :organisation

department = FactoryGirl.create :department, :organisation => organisation

# Sample Users
students =  %w( peter tom jack sarah ).map do |name|
  FactoryGirl.create :student,  { first_name: "#{name}",
                                  last_name: "cpp",
                                  email: "#{name}@cpp.com",
                                  password: "cppcppcpp",
                                  password_confirmation: "cppcppcpp",
                                  department: department
                                }
end

# Sample Companies
10.times do
  FactoryGirl.create :company, :organisation => organisation
end

Company.all.each do |company|
  # Create events
  5.times do
    FactoryGirl.create(:event, :company => company)
  end

  # Create placements
  5.times do
    FactoryGirl.create(:placement, :company => company)
  end

  1.times do
    FactoryGirl.create :company_administrator, {
      password: "cppcppcpp",
      password_confirmation: "cppcppcpp",
      company: company
    }
  end
end
