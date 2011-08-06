require 'yaml'

module Resque
  def self.swap server
    current = Resque.redis
    
    # Create Redis connection.
    Resque.redis = server_connect(server, @swapper_config[server])
    if block_given?
      yield Resque
      Resque.redis = current
    end
    Resque
  end
  
  def self.servers &block
    @swapper_config.collect do |server, config|
      swap(server, &block)
    end
  end
  
  def self.servers= (path)
    @swapper_redis = Hash.new
    if File.exists?(path)
      config = YAML.load_file(path)
      # Force configuration keys as symbols
      @swapper_config = Hash[config.collect {|n| [n[0].to_sym, Hash[n[1].collect{|c| [c[0].to_sym, c[1]] }] ] }]
    else
      puts "Warning: config file doesn't not exists."
    end
  end
  
  def self.server(server)
    server_connect(server, @swapper_config[server])
  end
  
  protected
    def self.server_connect(server, config)
      unless @swapper_redis[server]
        @swapper_redis[server] = Redis.new(config)
      end
      @swapper_redis[server]
    end
end