ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
end


require 'test/unit/ui/console/testrunner'
class Test::Unit::UI::Console::TestRunner
  def guess_color_availability 
    true 
  end
end