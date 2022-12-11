require 'redis'

# Singleton Class
class RedisStore
  class KeyDontExist < StandardError; end
  
  @instance = new
  private_class_method :new

  def self.instance
    @instance
  end

  def self.list
    @handler.keys
  end

  def self.delete(key)
    @handler.del(key)
  end

  def self.connect(host, port)
    @handler ||= Redis.new(host: host, port: port)
  end

  def self.set(key, value)
    @handler.set(key, value)
  end

  def self.get(key)
    value = @handler.get(key)
  end

  def self.increment(key)
    @handler.incr(key)
  end

  def self.setex(key, value, expiration)
    set(key, value)
    @handler.expire(key, expiration)
  end

  def self.flushdb
    @handler.flushdb
  end
end

RedisStore.connect('redis', 7479)
