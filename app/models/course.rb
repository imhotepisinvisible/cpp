# Schema Fields
#   t.string   "name"
#   t.datetime "created_at", :null => false
#   t.datetime "updated_at", :null => false

class Course < ActiveRecord::Base
###################### Declare associations ########################
  belongs_to :student

  ######################### Ensure present ###########################
  validates :name, :presence => true 

  ############ Attributes can be set via mass assignment ############
  attr_accessible :name

  def as_json(options={})
    #result[:student_id] = student.profile_id
    #result super(:methods => [:type])

    result[:student_id] = 1 #just testing 
    return result
  end


end
