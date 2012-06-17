require './test_helper'

class ResqueSwapperTest < Test::Unit::TestCase
  def setup
    current = Resque.redis
    Resque.redis.del('value')
    Resque.servers do |server|
      server.redis.del('value')
    end
    Resque.redis = current
  end

  def test_config
    assert_equal Resque.info[:environment], 'test'
    assert_equal Resque::Swapper.config, YAML.load_file('config/resque.yml')['test']
  end
  
  def test_swap
    current = Resque.redis
    
    Resque.swap(:merlin) do |resque|
      resque.redis.set('value', "I am Merlin!")
    end
    assert_same_db Resque.redis, current, "Current shound't be swapped after swap with block."
    
    Resque.swap(:aang) do |resque|
      resque.redis.set('value', "I am Aang!")
    end
    assert_same_db Resque.redis, current, "Current shound't be swapped after swap with block."
    
    Resque.swap(:aang)
     
    assert_same_db Resque.redis, Resque.server(:aang), "Current Redis should be swapped after direct swap."
    
    Resque.swap(:localhost)
    
    assert_equal nil, Resque.redis.get('value')
  end

  def test_swap_with_exception
    current = Resque.redis
    
    assert_raise(RuntimeError, "EGADS!") do
      Resque.swap(:merlin) do |resque|
        raise "EGADS!"
      end
    end

    assert_same_db Resque.redis, current, "Should swap back to starting db on exception"
  end

  def assert_same_db(redis1, redis2, msg)
    assert_equal redis1.client.db, redis2.client.db, msg
  end
end

