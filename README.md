# resque-swapper

Allows to configure and Resque servers to swap them on runtime.

# Configuration

Create a <code>config/resque.yml</code> for your project, like this:

    production:
      localhost:
        host: localhost
        port: 6379
      another:
        host: 192.168.1.5
        port: 6379
    development:
      localhost:
        host: localhost
        port: 6379
      another:
        host: localhost
        port: 6380
	
# How to use

Swaping temporarily:

	require 'resque-swapper'
	require 'resque-remote'
	
	Resque.swap(:another) do |resque|
		resque.remote_enqueue('SomeJob', :queue, 'foo')
	end
	
Direct swap:

	require 'resque-swapper'

	Resque.swap(:another)
	Resque.enqueue(Something, 'foo')


# License

resque-swapper is released under MIT License. Please see LICENSE file.
