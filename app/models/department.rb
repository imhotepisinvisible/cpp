class Department < ActiveRecord::Base
  belongs_to :organisation
  has_many :students
  #has_many :admins
  has_and_belongs_to_many :companies

  validates :name,         :presence => true

  # TODO do we need this with a belongs to?
  validates :organisation, :presence => true
end
