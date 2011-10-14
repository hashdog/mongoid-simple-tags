$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

class User
	include Mongoid::Document
	include Mongoid::Document::Taggable
	field :name
	belongs_to :organisation
end

class Organisation
	include Mongoid::Document
	field :name
	has_many :users
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
		cleanup_database
	end
end

describe "A Taggable model with scope" do
	before do 
		@organisation_1 = Organisation.create(name: 'Qualica')
		@user_1 = @organisation_1.users.create(name: 'User1', tag_list: "ubuntu, linux, tucuman")
		@user_2 = @organisation_1.users.create(name: 'User2', tag_list: "ubuntu, linux, tucuman")
		@organisation_2 = Organisation.create(name: 'Microsoft')
		@user_3 = @organisation_2.users.create(name: 'User3', tag_list: 'microsoft, windows, tucuman')
		@user_4 = @organisation_2.users.create(name: 'User4', tag_list: 'ubuntu, linux, tucuman')
	end

	it "should return scoped tags when passing one option" do 
		results = User.scoped_tags(organisation_id: @organisation_1.id)
		assert !results.empty?
		assert results.include?( {"_id"=>"linux", "value"=>2.0} )
		assert results.include?( {"_id"=>"ubuntu", "value"=>2.0} )
		assert results.include?( {"_id"=>"tucuman", "value"=>2.0} )
		
		results = User.scoped_tags(organisation_id: @organisation_2.id)
		assert !results.empty?
		assert results.include?( {"_id"=>"linux", "value"=>1.0} )
		 assert results.include?( {"_id"=>"microsoft", "value"=>1.0} )
		 assert results.include?( {"_id"=>"windows", "value"=>1.0} )
		 assert results.include?( {"_id"=>"tucuman", "value"=>2.0} )
	end

	it "should return scoped tags when passing more than one option" do
		results = User.scoped_tags(organisation_id: @organisation_1.id, name: @user_1.name)
		assert !results.empty?
		assert results.include?( {"_id"=>"linux", "value"=>1.0} )
		assert results.include?( {"_id"=>"ubuntu", "value"=>1.0} )
		assert results.include?( {"_id"=>"tucuman", "value"=>1.0} )
	end

	after do
		cleanup_database
	end

end

def cleanup_database
	Mongoid.database.collections.each do |collection|
		collection.remove if collection.name !=~ /^system\./ 
	end
end