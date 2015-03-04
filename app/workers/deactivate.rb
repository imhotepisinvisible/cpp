class Deactivate
  @queue = :activation

  def self.perform(student_id)
    student = Student.find(student_id)
    UserMailer.account_deactivated(student).deliver    
  end
end