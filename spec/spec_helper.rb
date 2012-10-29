require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  #
  # The Spork.prefork block is run only once when the spork server is started.
  # You typically want to place most of your (slow) initializer code in here, in
  # particular, require'ing any 3rd-party gems that you don't normally modify
  # during development.
  ENV["RAILS_ENV"] ||= 'test'

  # Avoid the User model from being always preloaded. See more info here:
  # https://github.com/sporkrb/spork/wiki/Spork.trap_method-Jujitsu
  require 'rails/application'
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  require 'mocha'

  require 'database_cleaner'
  require 'support/factory_helper'
  require 'support/behaviours'

  DatabaseCleaner.strategy = :truncation

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

  RSpec.configure do |config|
    config.mock_with :mocha
    config.use_transactional_fixtures = true

    # If you're using Devise, you can uncomment the following:
    # config.include Devise::TestHelpers, type: :controller

    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  #
  # The Spork.each_run block is run each time you run your specs.  In case you
  # need to load files that tend to change during development, require them here.
  # With Rails, your application modules are loaded automatically, so sometimes
  # this block can remain empty.
  #
  # Note: You can modify files loaded *from* the Spork.each_run block without
  # restarting the spork server.  However, this file itself will not be reloaded,
  # so if you change any of the code inside the each_run block, you still need to
  # restart the server.  In general, if you have non-trivial code in this file,
  # it's advisable to move it into a separate file so you can easily edit it
  # without restarting spork.  (For example, with RSpec, you could move
  # non-trivial code into a file spec/support/my_helper.rb, making sure that the
  # spec/support/* files are require'd from inside the each_run block.)

  # Delay loading FactoryGirl, otherwise our models will get preloaded and cached.
  require 'factory_girl_rails'
  FactoryGirl.reload
  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
  end

  # Empty the database
  DatabaseCleaner.clean

  # Rails.application.reload_routes!
end
