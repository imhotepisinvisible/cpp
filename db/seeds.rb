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

# Imperial Organisation
organisation = FactoryGirl.create :organisation, {
  :name => "Imperial College London"
}

# Imperial Email Domains
FactoryGirl.create :organisation_domain, {
  domain: "imperial.ac.uk",
  organisation: organisation
}

FactoryGirl.create :organisation_domain, {
  domain: "ic.ac.uk",
  organisation: organisation
}

# Department of Computing
department = FactoryGirl.create :department, {
  name:"Department of Computing",
  organisation: organisation
}

FactoryGirl.create :student,  {
  first_name: "Peter",
  last_name: "Hamilton",
  email: "peter.hamilton10@imperial.ac.uk",
  password: "cppcppcpp",
  password_confirmation: "cppcppcpp",
  year: 3,
  bio: "<p>Quite simply, I'm passionate about building awesome things with exciting technology.</p><p>I can usually be found hacking away on my latest project or evangelising  Ruby,  Rails, Git,  CoffeeScript,  Backbone.js,  TDD using RSpec or an API I've recently fallen in love with.</p>",
  degree: 'MEng Computing',
  cv_location: "#fakecvlocation",
  transcript_location: "#faketranscriptlocation",
  covering_letter_location: "#fakecoveringletterlocation",
  profile_picture_location: "/assets/pete_profile.jpg",
  department: department
}

FactoryGirl.create :student,  {
  first_name: "Jack",
  last_name: "Stevenson",
  email: "js3509@ic.ac.uk",
  password: "cppcppcpp",
  password_confirmation: "cppcppcpp",
  year: 3,
  bio: "<p>Hi, I'm Jack Stevenson, you may remember me from such towns as Trowbridge, Hilperton, Frome and Bath. I'm 17 years old, 5ft 10 , am a 1st Dan Blackbelt in Taekwondo and am also a certified and qualified assistant instructor. I am happiest when at Taekwondo, with my friends, on my stilts (which broke! Should be fixed soon (fingers crossed)) and, of course, when not awake or thinking.</p>",
  degree: 'MEng Computing',
  cv_location: "#fakecvlocation",
  transcript_location: "#faketranscriptlocation",
  covering_letter_location: "#fakecoveringletterlocation",
  profile_picture_location: "/assets/jack_profile.jpg",
  department: department
}

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
