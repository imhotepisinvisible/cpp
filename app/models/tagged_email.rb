# TaggedEmail class. for emails to all students matching a given set of tags.
class TaggedEmail < Email
  acts_as_taggable_on :skills, :interests, :year_groups
  attr_accessible :skill_list, :interest_list, :year_group_list

  # def as_json(options={})
  #   super(:include => [:skills, :interests, :year_groups])
  # end

  def as_json(options={})
    super(:methods => [:skill_list, :interest_list, :year_group_list])
  end

  def get_matching_students
    contexts = ["skills","interests"]
    students = Student.where(:active => true)
    puts students.inspect
    contexts.each do |c|
      reject_c = "reject_" + c
      students -= Student.tagged_with(self.send(c).map{|t| t.name}, :on => reject_c.to_sym, :any => true)
    end
    students
  end

  def send_email
    #email sending shiz to go here...
  end

end
