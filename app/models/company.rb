class Company < ActiveRecord::Base
	has_many :events
  has_many :placements
  has_and_belongs_to_many :departments

  validates :name, :presence => true
  validates :logo, :presence => true

  # TODO: test the messages
  validates :description, :length => {
    :in => 1..500,
    # :tokenizer => lambda { |str| str.scan(/\w+/) },
    :too_short => "must have at least %{count} characters",
    :too_long  => "must have at most %{count} characters"
  }
end
