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

  def send_email
  	users = Student.tagged_with(self.skills + self.interests + self.year_groups, :any => true)
  end

  def get_matching_students
    users = Student.tagged_with(self.skills + self.interests + self.year_groups, :any => true)
    users.length
  end
end
