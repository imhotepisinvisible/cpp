class Company < ActiveRecord::Base
	has_many :events
  has_many :placements
end
