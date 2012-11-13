source 'https://rubygems.org'

gem 'rails', '3.2.1'

# Twitter Bootstrapping
gem 'twitter-bootstrap-rails'

# Bootstrap Dependencies
gem 'therubyracer'
gem 'less-rails'

# Font Awesome = Icons via Font!
gem 'font-awesome-rails'

# Google Charts
gem "google_visualr", ">= 2.1"

# Date and time validation plugin for ActiveModel and Rails.
gem 'validates_timeliness', '~> 3.0'

# WYSIWYG editor for emails
gem 'tinymce-rails'

# Pagination
gem 'will_paginate'
gem 'bootstrap-will_paginate'

gem 'cantango' # Nice role based access control
gem 'bcrypt-ruby' # For password encryption

gem 'backbone-on-rails' # Nice client side JS framework
gem 'underscore-rails' # Templating for backboneJS

gem 'backbone-validation-rails'

gem 'thin' # Better server :)

gem 'rails-backbone-forms' # Client side form validation
gem 'bootstrap-datepicker-rails' # Date picker
gem 'datejs-rails'
gem 'jquery-fileupload-rails' # File upload
gem 'jcountdown-rails', :git => 'http://github.com/rezwyi/jcountdown-rails.git' #Countdown timer

gem 'bourbon' # Nice SCSS mixins

gem 'jquery-rails'
gem 'haml-rails'
gem 'simple_form'       # Nice forms
gem 'rufus-scheduler'   # Task Scheduling

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'pg' # Required by postgres
end

group :development do
  gem 'rails3-generators' # for factory_girl_rails and simple_form
  gem 'sqlite3'           # Local development
  gem 'lorem'
  gem 'rails-erd'

  # Auto-Run tests
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rb-fsevent'

  gem 'terminal-notifier-guard' # Notification center for test runs :)

  gem 'guard-livereload'
end

group :test, :development do
  gem 'jasmine'
  gem 'jasminerice'
  gem 'guard-jasmine'
  gem 'sinon-rails'
  gem 'jasmine-sinon-rails', :git => 'git://github.com/PeterHamilton/jasmine-sinon-rails'


  gem 'rspec-rails'
  gem 'rspec-instafail'

  gem 'factory_girl_rails', :require => false # Easy fixtures
  gem 'shoulda-matchers'

  gem 'pry' # Awesome developer console http://pryrepl.org/
  gem 'faker' # For faking data
  gem 'database_cleaner'
end

group :test do
  gem 'spork-rails'
  gem 'mocha', :require => false # Mocking for unit tests
end
