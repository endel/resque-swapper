require 'yaml'

module Resque
  def self.swap(server)
    current = Redis.current
    
    # Create Redis connection.
    @swapper_redis[server] = Redis.new(@swapper_config[server]) unless @swapper_redis[server]
    
    # Use this server as param if block was given.
    if block_given?
      yield @swapper_redis[server]
      current
    else
      # Set current Redis connection and return.
      Redis.current = @swapper_redis[server]
    end
  end
  
  def self.servers= (path)
    @swapper_redis = Hash.new
    @swapper_config = YAML.parse(File.open(path, 'r')) if File.exists(path)
  end
end