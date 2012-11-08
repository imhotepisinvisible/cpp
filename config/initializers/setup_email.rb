CPP::Application.config.action_mailer.raise_delivery_errors = true

  ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 587,
   :domain => 'gmail.com',
   :authentication => :plain,
   :user_name=>"impdoccpp@gmail.com",
   :password=>"cppcppcpp",
   :enable_starttls_auto => true
}