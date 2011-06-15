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
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "mongoid-simple-tags"
  gem.homepage = "http://github.com/chebyte/mongoid-simple-tags"
  gem.license = "MIT"
  gem.summary = %Q{tags on mongoid made easy}
  gem.description = %Q{basic and simple tagging system for mongoid}
  gem.email = "maurotorres@gmail.com"
  gem.authors = ["chebyte"]
  # dependencies defined in Gemfile
  gem.add_dependency('mongoid','>=2.0.0')
  
end
Jeweler::RubygemsDotOrgTasks.new

