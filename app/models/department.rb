class Department < ActiveRecord::Base
  has_many :students
  #has_many :admins
  belongs_to :organisation

  validates :name, :presence => true
end
