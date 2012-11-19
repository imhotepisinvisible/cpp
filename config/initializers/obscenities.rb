Obscenity.configure do |config|
  # config.blacklist   = "path/to/blacklist/file.yml"
  config.whitelist   = ["safe", "word"]
  config.replacement = :stars
end
