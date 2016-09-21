# encoding: utf-8

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
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "mousey_revenge"
  gem.homepage = "http://github.com/bobjflong/mousey_revenge"
  gem.license = "MIT"
  gem.summary = "A game of mice and cats"
  gem.description = "Move blocks, trap cats, turn them into cheese!"
  gem.email = "robertjflong@gmail.com"
  gem.authors = ["Bob Long"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :play do
  ENV['PLAY'] = '1'
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '.', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require 'mousey_revenge'
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mousey_revenge #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
