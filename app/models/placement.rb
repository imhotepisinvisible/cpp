class Placement < ActiveRecord::Base
  belongs_to :company

  validates :company,           :presence => true
  validates :position,          :presence => true
  validates :location,          :presence => true
  validates :description,       :presence => true
  validates_datetime :deadline, :after => :today
end
