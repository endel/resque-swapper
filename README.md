# resque-swapper

Allows to configure and Resque servers to swap them on runtime.

# Configuration file

Add *require 'resque-swapper/tasks'* into your Rakefile.
Generate your servers configuration file. By default will be created at config/resque.yml

	rake resque:config NAME=default HOST=localhost
	rake resque:config NAME=second HOST=x.x.x.x
	
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