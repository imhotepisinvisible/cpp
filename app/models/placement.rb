class Placement < ActiveRecord::Base
  belongs_to  :company

  validate  :company,      :presence => true 
  validate  :position,     :presence => true
  validate  :description,  :presence => true
  validate  :location,     :presence => true
  validate  :deadline,     :presence => true

end