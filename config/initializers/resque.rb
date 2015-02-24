require 'resque_scheduler'
Resque.redis = '172.17.0.3:6379'
Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")