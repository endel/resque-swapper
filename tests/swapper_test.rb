require './test_helper'

class ResqueSwapperTest < Test::Unit::TestCase
  def setup
    current = Resque.redis
    Resque.redis.flushdb
    Resque.servers.each do |server|
      server.flushdb
    end
    Resque.redis = current
  end
  
  def test_swap
    Resque.swap(:local) do |local|
      local.redis.set('value', 1)
    end
    assert_equal Resque.redis.get('value'), nil
  end
end