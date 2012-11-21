class EmailTagLink < ActiveRecord::Base
  belongs_to :email
  belongs_to :tag
end
