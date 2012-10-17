# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

team = %w( peter tom jack sarah )

team.each do |team_member|
  User.create([{email: "#{team_member}@cpp.com", :password => "cpp", :password_confirmation => "cpp"}])
end
