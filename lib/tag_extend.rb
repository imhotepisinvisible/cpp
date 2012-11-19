require 'obscenity/active_model'

module TagExtend
  def self.included(recipient)
    recipient.validates :name, obscenity: {:message => "Profanities Not Allowed!"}
  end
end
