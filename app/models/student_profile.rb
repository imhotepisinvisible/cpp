class StudentProfile < ActiveRecord::Base
  belongs_to :student

  # TODO: user_id?
  # validates :user_id,    :presence => true
  validates :year,       :presence => true
  validates :bio,        :presence => true
  validates :degree,     :presence => true


  validates :year, :inclusion => { :in => %w(1 2 3 4),
    :message => "%{value} is not a valid year" }

  # TODO: How much do we want to limit it to? Also do we want to force them to
  # have a bio? Should we make :in be 0..500?
  validates :bio, :length => {
    :in => 1..500,
    :too_short => "must have at least %{count} characters",
    :too_long  => "must have at most %{count} characters"
  }

  validate :year_must_be_valid_for_degree

  # TOOD: What are all the degrees?
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
      errors.add(:degree, "Degree isn't valid")
    end

    if range and !range.cover?(year.to_i)
      errors.add(:year, "Year is not valid for degree type %{:degree}")
    end
  end
end
