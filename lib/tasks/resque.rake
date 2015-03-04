require 'resque/tasks'
require 'resque_scheduler/tasks'
require 'resque_scheduler'

task "resque:setup" => :environment do
	require 'resque'
	require 'resque/scheduler'
end