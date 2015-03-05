Rails.application.config.middleware.use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = SessionsController.action(:warden_fail)
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

Warden::Strategies.add(:password) do
	def authenticate!
    user = User.find_by_email(params['session']['email'])
    if user && user.authenticate(params['session']['password'])
      success! user
    else
      #fail
    end
  end
end
