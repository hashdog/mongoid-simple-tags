$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

class User
	include Mongoid::Document
	include Mongoid::Document::Taggable
	field :name
end

describe "A Taggable model" do
	before do
		@user = User.new(name: 'Tuquito')
	end

	it "should have a tag_list method" do
		@user.respond_to?(:tag_list)	
	end

	it "should be able to update a tag list" do
		tag_list = "linux, tucuman, free software"
		tags = tag_list.split(',').map{ |tag| tag.strip}.flatten
		@user.tag_list = tag_list
		assert_equal tags, @user.tags
	end
end

describe "A Taggable model with tags assigned" do

	before do 
		@tag_list = "linux, tucuman, free software"
		@user = User.new(name: 'Tuquito')
		@user.tag_list = @tag_list
		@user.save
	end

	it "should be able to find tagged_with objects" do 
		assert_equal @user, User.tagged_with('linux').first
		assert_equal @user, User.tagged_with(['tucuman', 'free software']).first
	end

	it "should be able to find tagged_with objects if more than one object is present" do
					user2 = User.new(name: 'ubuntu')
					user2.tag_list = "linux"
					user2.save
					tagged_with_list = User.tagged_with('linux')
					assert tagged_with_list.include? @user
					assert tagged_with_list.include? user2
	end

	it "should return all_tags per Model class" do
					user2 = User.create(name: 'ubuntu', tag_list: 'linux')
					all_tags_for_users = User.all_tags
					expected_tag_list = [ {:name=>"free software", :count=>1},
								 								{:name=>"linux", :count=>2},
															 	{:name=>"tucuman", :count=>1}
															]
					assert_equal expected_tag_list, all_tags_for_users
	end

	after do 
		Mongoid.database.collections.each do |collection|
			collection.remove if collection.name !=~ /^system\./ 
		end
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


