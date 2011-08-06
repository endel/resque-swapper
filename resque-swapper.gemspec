require 'rake/gempackagetask'
require 'rake/rdoctask'

VERSION = '0.1'

Gem::Specification.new do |s|
  s.name = 'resque-swapper'
  s.version = VERSION
  s.summary = 'Swapping tool for Resque server on runtime.'
  s.homepage = "http://github.com/endel/resque-swapper"
  
  s.author = 'Endel Dreyer'
  s.email = 'endel.dreyer@gmail.com'
  s.files = %w(LICENSE) + Dir.glob("{lib}/**/*")
  s.require_path = "lib"
  # s.bindir = "bin"
  
  s.description = <<description
    Swapping tool for Resque server on runtime.
description
end