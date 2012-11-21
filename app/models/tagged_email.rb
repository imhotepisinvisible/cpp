# TaggedEmail class. for emails to all students matching a given set of tags.
class TaggedEmail < Email

  acts_as_taggable_on :skills, :interests, :year_groups

  def as_json(options={})
    super(:include => [:skills, :interests, :year_groups])
  end

end
