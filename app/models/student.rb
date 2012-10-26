class Student < User
  default_scope :include => :profile
  
  has_one :profile, :class_name => "StudentProfile", :foreign_key => "student_id", :autosave => true

  delegate :year, :year=, :bio, :bio=, :degree, :degree=, :to => :profile
end
