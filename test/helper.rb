require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/autorun'
require 'minitest/spec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mongoid'
require 'mongoid-simple-tags'


require 'yaml' 
YAML::ENGINE.yamler= 'syck'


#mongoid_config_path = File.join(Pathname.new(__FILE__).dirname, "mongoid_test.yml")
#Mongoid.load!(mongoid_config_path)
Mongoid.configure do |config|
	config.master = Mongo::Connection.new.db("mongoid_simple_tags_test")
end


