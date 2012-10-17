class Event < ActiveRecord::Base
	belongs_to :company

	validates :company_id,   :presence => true
	validates :title,        :presence => true
  # TODO: start_date and end_date need to be validated
	validates :start_date,   :presence => true
  validates :end_date,     :presence => true
	validates :description,  :presence => true
	validates :location,     :presence => true
end
