# app/models/placement.rb
#
# Companies can advertise placements to students in different departments
#
# Schema Fields
#   t.integer  "company_id"
#   t.string   "position"
#   t.text     "description"
#   t.string   "duration"
#   t.string   "location"
#   t.datetime "deadline"
#   t.datetime "created_at",  :null => false
#   t.datetime "updated_at",  :null => false

class Placement < ActiveRecord::Base
  belongs_to :company

  validates :company_id,        :presence => true
  validates :position,          :presence => true
  validates :location,          :presence => true
  validates :description,       :presence => true
  validates_datetime :deadline,
    :after => :now,
    :after_message => "Cannot be in the past"

end
