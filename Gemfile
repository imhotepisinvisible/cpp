source 'https://rubygems.org'

# Config/Server
gem 'thin'                        # Better server :)
gem 'rails', '3.2.1'              # Running on rails, wooo
gem 'therubyracer'                # Javascript Engine

# Back End Gems
gem 'validates_timeliness'        # Date/Time Validation
gem 'cantango'                    # Nice RBAC
gem 'bcrypt-ruby'                 # For password encryption
gem 'haml-rails'                  # Support HAML Templates in Rails
gem 'simple_form'                 # Nicer forms in rails
gem 'rufus-scheduler'             # Task Scheduling
gem 'acts-as-taggable-on'         # Tagging framework
gem 'rails3_acts_as_paranoid'     # Hides records instead of deleting them, being able to recover them.
gem 'acts_as_list'                # Re-orderable lists
gem 'newrelic_rpm'                # Newrelic Monitoring
gem 'paperclip'                   # Nice model attachment
gem 'obscenity'                   # Obscenity filter
gem 'lorem'                       # Simple Lorem
gem 'impressionist'               # Stats & Logging

# UI/Appearance Related Gems
gem 'less-rails'                  # Less required for Bootstrap
gem 'twitter-bootstrap-rails'     # Twitter Bootstrap <3 Rails
gem 'bourbon'                     # Nice SCSS mixins
gem 'font-awesome-rails'          # Font Awesome = Icons
gem "google_visualr", ">= 2.1"    # Google Charts
gem 'tinymce-rails'               # WYSIWYG editor for emails
gem 'will_paginate'               # Basic Pagination
gem 'bootstrap-will_paginate'     # Bootstrap Pagination Integration
gem 'jquery-ui-rails'             # JQuery user interface plugin

# JS Frameworks/Plugins
gem 'jquery-rails'                # Add jQuery goodness
gem 'backbone-on-rails'           # Nice client side JS framework
gem 'backbone-validation-rails'   # Adds model validation in Backbone
gem 'underscore-rails'            # Templating for backboneJS
gem 'rails-backbone-forms'        # Client side form validation
gem 'bootstrap-datepicker-rails'  # Date picker
gem 'datejs-rails'                # Nicer date manipulation in Javascript
gem 'jquery-fileupload-rails'     # File upload
gem 'jcountdown-rails', :git => 'http://github.com/rezwyi/jcountdown-rails.git' #Countdown timer
gem 'bootstrap-toggle-buttons-rails', :git => 'http://github.com/wafcio/bootstrap-toggle-buttons-rails.git' # On/Off switches

group :assets do
  gem 'sass-rails',   '~> 3.2.3' # SASS for nicer CSS
  gem 'coffee-rails', '~> 3.2.1' # Coffeescript is the bomb
  gem 'uglifier', '>= 1.0.3'     # For minimising all our JS together in prod
end

group :production do
  gem 'pg' # Postgres Database Support
end

group :development do
  gem 'rails3-generators' # for factory_girl_rails and simple_form
  gem 'sqlite3'           # Local development
  gem 'rails-erd'         # Generate ERD diagrams with Rake
  gem 'guard-rspec'       # Auto-Run rspec Tests
  gem 'guard-spork'       # Auto-Reload Spork
  gem 'guard-livereload'  # Auto-Browser-Reload when files change
  gem 'rb-fsevent'        # Watch file system events (for Guard)

  gem 'terminal-notifier-guard' # Notification center for test runs :)
end

group :test, :development do
  gem 'jasmine'               # TDD for Javascript testing framework
  gem 'jasminerice'           # Jasmine for Coffeescript
  gem 'guard-jasmine'         # Auto Re-run Jasmine Tests
  gem 'sinon-rails'           # Sinon matchers for basic JS
  gem 'jasmine-sinon-rails'   # Sinon matchers for Jasmine
  gem 'jasmine-jquery-rails'  # JQuery Matchers and Fixtures for Jasmine

  gem 'spork-rails'           # Spork for pre-loading RSpec
  gem 'rspec-rails'           # Use RSpec for Testing
  gem 'rspec-instafail'       # Add instafail so broken/failing tests don't take ages
  gem 'shoulda-matchers'      # Helpful for RSpec testing

  gem 'pry-rails'             # Awesome developer console http://pryrepl.org/
  gem 'faker'                 # For faking data
  gem 'database_cleaner'      # For tests, wipe database between tests

  gem 'factory_girl_rails', :require => false # Easy fixtures
end

group :test do
  gem 'mocha', :require => false # Mocking for unit tests
end
