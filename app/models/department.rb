class Department < ActiveRecord::Base
  belongs_to :organisation
  has_many :students
  #has_many :admins
  has_and_belongs_to_many :companies

  validates :name,         :presence => true

  validates :organisation_id, :presence => true
end
