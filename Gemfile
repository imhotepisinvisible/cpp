source 'https://rubygems.org'

gem 'rails', '3.2.1'

# Twitter Bootstrapping
gem 'twitter-bootstrap-rails'

# Font Awesome = Icons via Font!
gem 'font-awesome-rails'

# Google Charts
gem "google_visualr", ">= 2.1"

# Date and time validation plugin for ActiveModel and Rails.
gem 'validates_timeliness', '~> 3.0'

# Pagination
gem 'will_paginate'
gem 'bootstrap-will_paginate'

gem 'cantango' # Nice role based access control
gem 'bcrypt-ruby' # For password encryption

gem 'backbone-on-rails' # Nice client side JS framework
gem 'underscore' # Templating for backboneJS

gem 'thin' # Better server :)

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'haml-rails'
gem 'simple_form'       # Nice forms
gem 'rufus-scheduler'   # Task Scheduling

group :production do
  gem 'pg' # Required by postgres
end

group :development do
  gem 'rails3-generators' # for factory_girl_rails and simple_form
  gem 'heroku'            # Useful for deploying for demos
  gem 'sqlite3'           # Local development
  gem 'lorem'
  gem 'rails-erd'

  # Auto-Run tests
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rb-fsevent'
end

group :test, :development do
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
  # Mocking for unit tests
  gem 'mocha', :require => false
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
