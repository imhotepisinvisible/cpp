Obscenity.configure do |config|
  config.blacklist   = ["boob", "cock", "poo"]
  config.whitelist   = ["safe", "word"]
  config.replacement = :stars
end
