require 'yaml'

module Resque
  def self.swap(server)
    server = server.to_sym
    current = Redis.current
    
    # Create Redis connection.
    server_connect(server, @swapper_config[server])
    
    # Use this server as param if block was given.
    Resque.redis = @swapper_redis[server]
    if block_given?
      yield Resque
      Resque.redis = current
    end
    Resque.redis
  end
  
  def self.servers
    @swapper_config.collect do |server, config|
      puts config.inspect
      server_connect(server, config)
    end
  end
  
  def self.servers= (path)
    @swapper_redis = Hash.new
    if File.exists?(path)
      @swapper_config = YAML.load_file(path)
      puts @swapper_config.inspect
    else
      puts "Warning: config file doesn't not exists."
    end
  end
  
  protected
    def self.server_connect(server, config)
      server = server.to_sym
      unless @swapper_redis[server]
        @swapper_redis[server] = Redis.new(config)
      end
      @swapper_redis[server]
    end
end