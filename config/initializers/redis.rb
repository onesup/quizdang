module RedisClient
 class << self
   def redis
     @redis ||= Redis.new
   end
 end
end
