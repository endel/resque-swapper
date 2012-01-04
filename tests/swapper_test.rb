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
    assert_equal Resque.redis.id, current.id, "Current shound't be swapped after swap with block."
    
    Resque.swap(:aang) do |resque|
      resque.redis.set('value', "I am Aang!")
    end
    assert_equal Resque.redis.id, current.id, "Current shound't be swapped after swap with block."
    
    Resque.swap(:aang)
    assert_equal Resque.redis.id, Resque.server(:aang).id, "Current Redis should be swapped after direct swap."
    
    Resque.swap(:localhost)
    
    assert_equal nil, Resque.redis.get('value')
  end
end

