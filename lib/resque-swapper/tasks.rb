require 'fileutils'

namespace 'resque' do
  desc 'Append configuration to Resque server.'
  task 'config' do
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
    puts "Write into #{file}: "
    puts append_config
  end
end