require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'jeweler'
Jeweler::Tasks.new do |gem|
  # Gem::Specification... see http://docs.rubygems.org/read/chapter/20
  gem.name = "virt"
  gem.homepage = "https://github.com/ohadlevy/virt"
  gem.license = "GPLv3"
  gem.summary = %Q{Simple to use ruby interface to libvirt}
  gem.description = %Q{Simplied interface to use ruby the libvirt ruby library}
  gem.email = "ohadlevy@gmail.com"
  gem.authors = ["Ohad Levy"]

  #gem.add_runtime_dependency 'libvirt', '> 0.2.0'
  #gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/*test*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "hello-gem #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

