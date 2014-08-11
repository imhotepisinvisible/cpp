# TaggedEmail class. For emails to all students matching a given set of tags.
class TaggedEmail < Email
  ########################## Declare tags ###########################
  acts_as_taggable_on :skills, :interests, :year_groups

  ####################################################################
  # Attributes not to store in database direectly and exist
  # for life of object
  # ##################################################################
  attr_accessible :skill_list, :interest_list, :year_group_list, :graduating_year

  # Return JSON object 
  def as_json(options={})
    super(:methods => [:skill_list, :interest_list, :year_group_list])
  end

  # Return students that should receive email based on tags
  def get_matching_students
    contexts = ["skills","interests"]
    if self.graduating_year
      students = Student.where(:year => self.graduating_year)
    else
      students = Student.all
    end
    puts students.map{|s| s.first_name}.to_s
    contexts.each do |c|
      puts "Context: " + c
      puts c.to_sym
      if self.send(c).size > 0
        puts "Context " + c + " has tags " + self.send(c).map{|t| t.name}.to_s
        contextStudents = Student.tagged_with(self.send(c).map{|t| t.name}, :on => c.to_sym)
        puts "Students matching context " + c + ": " + contextStudents.map{|s| s.first_name}.to_s
        students = students & contextStudents
        puts students.map{|s| s.first_name}
      end
    end
    students
  end

end
