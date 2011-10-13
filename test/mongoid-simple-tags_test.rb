$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

class User
	include Mongoid::Document
	include Mongoid::Document::Taggable
	field :name
end

describe "A Taggable model" do

	it "should have a tag_list method" do

	end
end
#u = User.new(:name => "Tuquito")
#u.tag_list = "linux, tucuman, free software"      
#u.tags     # => ["linux","tucuman","free software"]
#u.save

#User.tagged_with("linux") # => u
#User.tagged_with(["tucuman", "free software"]) # => u

#u2 = User.new(:name => "ubuntu")
#u2.tag_list = "linux"
#u2.save

#User.tagged_with("linux") # => [u, u2]

#using map-reduce function
#
#User.all_tags #=>[{:name=>"free software", :count=>1}, {:name=>"linux", :count=>2}, {:name=>"tucuman", :count=>1}]


