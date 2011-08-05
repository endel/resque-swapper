require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'

VERSION = '0.1'

spec = Gem::Specification.new do |s|
  s.name = 'resque-swapper'
  s.version = VERSION
  s.summary = 'Runtime Resque server swapping tool.'
  s.description = s.summary
  s.author = 'Endel Dreyer'
  s.email = 'endel.dreyer@gmail.com'
  s.files = %w(LICENSE Rakefile) + Dir.glob("{lib}/**/*")
  s.require_path = "lib"
  # s.bindir = "bin"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['lib/**/*.rb']
  rdoc.rdoc_files.add(files)
#  rdoc.main = "README.rdoc"
  rdoc.title = "harvester Docs"
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers'
end

task :install do
  rm_rf "pkg/*.gem"
  puts `rake gem`
  puts `gem install pkg/harvester-#{VERSION}.gem`
end
