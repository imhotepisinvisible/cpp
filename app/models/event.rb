class Event < ActiveRecord::Base
	belongs_to :company

	validates :company_id,   :presence => true
	validates :title,        :presence => true
	validates :description,  :presence => true
	validates :location,     :presence => true

  validates_datetime :start_date, :after => :today
  validates_datetime :end_date,   :after => :start_date

end
