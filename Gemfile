source 'https://rubygems.org'

# Config/Server
gem 'thin'                        # Better server :)
gem 'unicorn'                     # Unicorn webserver: better for running on a VM
gem 'rails', '3.2.21'             # Running on rails, wooo
gem 'therubyracer', '0.12.1'      # Javascript Engine

# Back End Gems
gem 'validates_timeliness'        # Date/Time Validation
gem 'cantango'                    # Nice RBAC
gem 'haml-rails'                  # Support HAML Templates in Rails
gem 'simple_form'                 # Nicer forms in rails
gem 'rufus-scheduler'             # Task Scheduling
gem 'acts-as-taggable-on'         # Tagging framework
gem 'acts_as_paranoid', '~>0.4.0' # Hides records instead of deleting them, being able to recover them.
gem 'acts_as_list'                # Re-orderable lists
gem 'newrelic_rpm'                # Newrelic Monitoring
gem 'paperclip'                   # Nice model attachment
gem 'aws-sdk'                     # AWS SDK for paperclip uploads
gem 'redis'                       # Allows connection to redis server
gem 'resque', :require => 'resque/server'                      # Job Queueing system
gem 'resque-scheduler', '~> 2.2.0' #, :require => 'resque_scheduler' # Job scheduling
gem 'resque_mailer'               # Email queueing gem
gem 'obscenity'                   # Obscenity filter
gem 'lorem'                       # Simple Lorem
gem 'impressionist'               # Stats & Logging
gem 'workflow'                    # Handling approval states
gem 'rubyzip', '>= 1.0.0'         # will load new rubyzip version
gem 'zip-zip'                     # will load compatibility for old rubyzip API.
gem 'devise'                      # More customiseable authorisation

# UI/Appearance Related Gems
gem 'less-rails'                  # Less required for Bootstrap
gem 'twitter-bootstrap-rails', '~>2.2.7'     # Twitter Bootstrap <3 Rails
gem 'bourbon'                     # Nice SCSS mixins
gem 'font-awesome-rails', '~> 3.2.1' # Font Awesome = Icons
gem "google_visualr", ">= 2.1"    # Google Charts
gem 'tinymce-rails'               # WYSIWYG editor for emails
gem 'kaminari'                    # Pagination of backend collections
gem 'api-pagination'              # Give backbone the pagination information
gem 'jquery-ui-rails'             # JQuery user interface plugin
gem 'backgridjs-rails'

# JS Frameworks/Plugins
gem 'jquery-rails'                # Add jQuery goodness
gem 'backbone-on-rails', '0.9.10.0'# Nice client side JS framework
gem 'backbone-validation-rails'   # Adds model validation in Backbone
gem 'underscore-rails'            # Templating for backboneJS
gem 'rails-backbone-forms', '0.11.1' # Client side form validation
gem 'bootstrap-datepicker-rails'  # Date picker
gem 'momentjs-rails'              # Nicer date manipulation in Javascript
gem 'jquery-fileupload-rails'     # File upload
gem 'rails-bootstrap-toggle-buttons' # On/Off switches
gem 'highcharts-rails'
gem 'backbone-paginator-rails'

group :assets do
  gem 'sass-rails',   '~> 3.2.3' # SASS for nicer CSS
  gem 'coffee-rails', '~> 3.2.1' # Coffeescript is the bomb
  gem 'uglifier', '>= 1.0.3'     # For minimising all our JS together in prod
end

group :development, :test do
  gem 'rspec-rails'           # Use RSpec for Testing
  gem 'spork-rails'           # Spork for pre-loading RSpec
  gem 'shoulda-matchers'      # Helpful for RSpec testing
  gem 'simplecov'             # For code coverage stats

  gem 'teaspoon-jasmine'      # Javascript TDD/BDD runner (includes Jasmine)
  gem 'phantomjs'             # For running headless tests

  gem 'pry-rails'             # Awesome developer console http://pryrepl.org/
  gem 'faker'                 # For faking data
  gem 'factory_girl_rails', :require => false # Easy fixtures
  gem 'database_cleaner'      # For tests, wipe database between tests
end

group :development do
  gem 'sqlite3'           # Local development
  gem 'rails-erd'         # Generate ERD diagrams with Rake
end

group :production do
  gem 'pg' # Postgres Database Support
end

group :test do
  gem 'mocha', :require => false # Mocking for unit tests
end
