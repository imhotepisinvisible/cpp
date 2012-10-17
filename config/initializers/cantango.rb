CanTango.config do |config|
  config.debug.set :on
  config.permits.disable :account, :special, :role_group
  config.engines.all :on

  # Leave :off till permits working
  config.engine(:permission).set :off
  config.engine(:cache).set :off
end
