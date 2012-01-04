require 'yaml'

module Resque
  extend self

  module Swapper
    extend self

    def load(path)
      @swapper_config = Hash.new
      if File.exists?(path)
        @swapper_config = YAML.load_file(path)
      else
        puts "Warning: config file doesn't not exists."
      end
    end

    def config(server=nil)
      c = @swapper_config[Resque.info[:environment]]
      server.nil? ? c : c[server.to_s]
    end
  end

  def swap server
    current = Resque.redis

    # Create Redis connection.
    Resque.redis = server_connect(server, Swapper.config(server))
    if block_given?
      yield Resque
      Resque.redis = current
    end
    Resque
  end
  
  def servers &block
    Swapper.config.collect do |server, config|
      swap(server, &block)
    end
  end

  def server(server)
    server_connect(server, Swapper.config(server))
  end
  
  protected
    def server_connect(server, config)
      @swapper_redis ||= {}

      unless @swapper_redis[server]
        # Force configuration keys as symbols
        @swapper_redis[server] = Redis.new(Hash[config.collect {|n| [n[0].to_sym, n[1] ] }])
      end
      @swapper_redis[server]
    end
end
