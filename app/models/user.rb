# app/models/user.rb
#
# A user is more 'abstract'. It contains password and email fields for auth
#
# Schema Fields
#   t.string   "email"
#   t.string   "password_digest"
#   t.integer  "department_id"
#   t.datetime "created_at",      :null => false
#   t.datetime "updated_at",      :null => false

class User < ActiveRecord::Base
  belongs_to :organisation
  attr_accessible :email, :password, :password_confirmation

  has_secure_password

  validates :email,           :presence => true
  validates :password_digest, :presence => true, :on => :create

  validates :password, :length => {
    :minimum => 8,
    :too_short => "password is too short, must be at least %{count} characters"
  }, :on => :create

end
