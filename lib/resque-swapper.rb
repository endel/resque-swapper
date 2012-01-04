require 'resque'
require 'resque-swapper/resque-swapper'

if File.exists?('config/resque.yml')
  Resque::Swapper.load('config/resque.yml')
end
