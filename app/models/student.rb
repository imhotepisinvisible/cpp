class Student < User
  belongs_to :department

  has_one :profile,
          :class_name => "StudentProfile",
          :foreign_key => "student_id",
          :autosave => true,
          :dependent => :destroy,
          :inverse_of => :student

  default_scope :include => :profile

  delegate :year, :year=, :bio, :bio=, :degree, :degree=, :to => :profile
end
