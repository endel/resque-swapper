require 'fileutils'

namespace 'resque' do
  desc 'Append configuration to Resque server.'
  task 'config' do
    name = ENV['NAME'] || 'default'
    host = ENV['HOST'] || 'localhost'
    port = ENV['PORT'] || '6379'
    
    file = 'config/resque.yml'
    FileUtils.mkdir_p('config')

    server = {'name' => {'host' => host, 'port' => port}}

    configuration = (File.exists?(file)) ? YAML.load_file(file) : {}
    %w{production development test}.each do |env|
      configuration[env] = server
    end
    
    File.open(file, 'w+') {|f| f.write(configuration.to_yaml) }
    "#{file} was updated."
  end
end
