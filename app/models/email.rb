class Email < ActiveRecord::Base
  has_one :company

  validates :company_id, :presence => true
end
