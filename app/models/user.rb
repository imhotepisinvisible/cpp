class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_secure_password

  validates :email,           :presence => true
  validates :password_digest, :presence => true, :on => :create

  validates :password, :length =>
    { :minimum => 8,
      :too_short => "password is too short, must be at least %{count} characters"
    }
end
