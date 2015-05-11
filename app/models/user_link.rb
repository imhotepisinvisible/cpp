class UserLink < ActiveRecord::Base
    ###################### Declare associations ########################
  belongs_to :student  #belongs to student model
  
  attr_accessible :student_id, :gitHub, :linkedIn, :personal, :other

  #Returns as JSON
  def as_json(options={})
    super(:include => :student)
  end
end
