require 'resque_scheduler'
Resque.redis = 'redis:6379'
Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")