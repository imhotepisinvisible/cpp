class Company < ActiveRecord::Base
	has_many :events
  has_many :placements

  validates :name,        :presence => true

  # TODO: test the messages
  validates :description, :length => {
    :in => 1..500,
    # :tokenizer => lambda { |str| str.scan(/\w+/) },
    :too_short => "must have at least %{count} characters",
    :too_long  => "must have at most %{count} characters"
  }
end
