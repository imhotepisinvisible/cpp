$redis = Redis.new(:host => 'localhost', :port => 6379)
puts $redis.inspect