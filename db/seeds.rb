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

organisation = FactoryGirl.create :organisation_with_domains

department = FactoryGirl.create :department, :organisation => organisation

# Tags
year_group_category = FactoryGirl.create :tag_category, :name => "Year Groups"
programming_category = FactoryGirl.create :tag_category, :name => "Programming Languages"
segment_category = FactoryGirl.create :tag_category, :name => "Industry Segments"

year_group_tags = [ '1st Year', '2nd Year', '3rd Year', '4th Year' ]
programming_tags = [ 'C', 'C++', 'Java', 'Ruby', 'Haskell' ]
segment_tags = [ 'Web Development', 'Banking', 'Games Development', 'Business' ]

year_group_tags.map do |name|
  FactoryGirl.create :tag, { name: "#{name}", tag_category: year_group_category }
end

programming_tags.map do |name|
  FactoryGirl.create :tag, { name: "#{name}", tag_category: programming_category }
end

segment_tags.map do |name|
  FactoryGirl.create :tag, { name: "#{name}", tag_category: segment_category }
end

# Sample Users
students =  %w( peter tom jack sarah ).map do |name|
  FactoryGirl.create :student,  { first_name: "#{name}",
                                  last_name: "cpp",
                                  email: "#{name}@inspiredpixel.net",
                                  password: "cppcppcpp",
                                  password_confirmation: "cppcppcpp",
                                  year: 1,
                                  bio: "Jack is the best!",
                                  degree: 'MEng in Awesome',
                                  department: department,
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
