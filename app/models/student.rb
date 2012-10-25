class Student < User
  default_scope :include => :profile
  
  has_one :profile, :class_name => "StudentProfile", :autosave => true

  delegate :year, :year=, :bio, :bio=, :degree, :degree=, :to => :student_profile
end
