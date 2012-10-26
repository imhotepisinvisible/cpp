class User < ActiveRecord::Base
  belongs_to :organisation
  attr_accessible :email, :password, :password_confirmation

  has_secure_password

  # TODO: Validate students have only IC/other email addresses.
  validates :email,           :presence => true
  validates :password_digest, :presence => true, :on => :create

  # validates :type, :inclusion => { :in => %w(Student),
  #   :message => "%{type} is not a valid user type" }

  validates :password, :length =>{
    :minimum => 8,
    :too_short => "password is too short, must be at least %{count} characters"
  }, :on => :create

end
