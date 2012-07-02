require 'mongoid'
require 'mongoid-simple-tags'

Mongoid.configure do |config|
	config.master = Mongo::Connection.new.db("mongoid_simple_tags_test")
end


