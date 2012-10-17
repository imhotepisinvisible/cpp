class Company < ActiveRecord::Base
	has_many :events
  has_many :placements

  validates :name,        :presence => true

  # TODO: test the messages
  validates :description, :length => {
    :in => 1..80,
    :tokenizer => lambda { |str| str.scan(/\w+/) },
    :too_short => "must have at least %{count} words",
    :too_long  => "must have at most %{count} words"
  }
end
