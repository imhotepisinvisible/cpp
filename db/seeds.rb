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

# Sample Users
team = %w( peter tom jack sarah )
team.each do |team_member|
  s = FactoryGirl.create :student,  { email: "#{team_member}@cpp.com",
                                      password: "cppcppcpp",
                                      password_confirmation: "cppcppcpp"
                                    }
end

# Sample Companies
10.times do
  FactoryGirl.create :company
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
end
