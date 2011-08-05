require 'fileutils'

namespace 'resque' do
  desc 'config' do
    name = ENV['NAME'] || 'default'
    host = ENV['HOST'] || 'localhost'
    port = ENV['PORT'] || '6379'
    
    file = 'config/resque.yml'
    FileUtils.mkdir_p('config')
    
    append_config = <<YML
#{name}:
  host: #{host}
  port: #{port}

YML
    File.open(file, 'a') do |f|
      f.write(append_config)
    end
  end
end