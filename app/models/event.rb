class Event < ActiveRecord::Base
	belongs_to :company

	validates :company_id,   :presence => true
	validates :title,        :presence => true
	validates :date,         :presence => true
	validates :description,  :presence => true
	validates :location,     :presence => true
end