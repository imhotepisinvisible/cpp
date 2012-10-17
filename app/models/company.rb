class Company < ActiveRecord::Base
	has_many :events
  has_many :placements

  validates :name,        :presence => true
  
  validates :description, :presence => true
  validates :description, :length => {
    :maximum   => 80,
    :tokenizer => lambda { |str| str.scan(/\w+/) },
    :too_short => "must have at least %{count} words",
    :too_long  => "must have at most %{count} words"
  }
end