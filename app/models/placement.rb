class Placement < ActiveRecord::Base
  belongs_to :company

  validates :company,     :presence => true
  validates :position,    :presence => true
  validates :location,    :presence => true
  validates :deadline,    :presence => true
  validates :description, :presence => true
end
