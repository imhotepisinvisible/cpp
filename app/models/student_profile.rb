class StudentProfile < ActiveRecord::Base
  belongs_to :student
  validates :student,  :presence => true

  # TODO: Can't test this using a factory as each point
  # to each other. How to fix?
  # validates :student_id, :presence => true
  validates :year,       :presence => true
  validates :bio,        :presence => true
  validates :degree,     :presence => true

  # TODO: How much do we want to limit it to? Also do we want to force them to
  # have a bio? Should we make :in be 0..500?
  validates :bio, :length => {
    :in => 1..500,
    :too_short => "must have at least %{count} characters",
    :too_long  => "must have at most %{count} characters"
  }

  validate :year_must_be_valid_for_degree

  # TOOD: How can we get degree only degrees?
  def year_must_be_valid_for_degree
    range = nil
    case degree
    when "MEng", "PhD"
      range = 1..4
    when "BEng"
      range = 1..3
    when "Msc"
      range = 1..1
    else
      errors.add(:degree, "#{degree} isn't a valid degree type")
    end

    if range and !range.cover?(year)
      errors.add(:year, "#{year} is not valid for degree type #{degree}")
    end
  end
end
