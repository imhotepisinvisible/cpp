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
    contexts.each {|c| students -= Student.tagged_with(self.send c.to_sym, :on => c.to_sym, :exclude => true)}
    students
  end

  def get_matching_students_count
    users = get_matching_students
    year_groups = Hash.new(0)
    users.each do |user|
      year_groups[user.year] += 1
    end
    year_groups
  end

  def send_email
    #email sending shiz to go here...
  end

end
