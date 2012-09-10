require 'spec_helper'

class User
  include Mongoid::Document
  include Mongoid::Document::Taggable
  field :name
  belongs_to :organization
end

class Organization
  include Mongoid::Document
  field :name
  has_many :users
end


describe "A Taggable model" do

  let(:user) { User.new(name: 'Tuquito') }

  it "should have a tag_list method" do
    user.respond_to?(:tag_list)  
  end

  it "should be able to update a tag list" do
    tag_list = "linux, tucuman, free software"
    tags = tag_list.split(',').map{ |tag| tag.strip}.flatten
    
    user.tag_list = tag_list
    user.tags.should == tags
  end

  it "returns an empty array if there are no tags" do
    user.tags = nil
    user.tags.should_not be_nil
    user.tags.should eql([])
  end

end


describe "A Taggable model with tags assigned" do

  before(:each) do
    @user = User.create!(name: 'Tuquito', tag_list: "linux, tucuman, free software")
  end
  
  it "should be able to find tagged_with objects" do 
    User.tagged_with('linux').first.should == @user
    User.tagged_with(['tucuman', 'free software']).first.should == @user
  end

  it "should be able to find tagged_with objects if more than one object is present" do
    user_2 = User.create!(name: 'ubuntu', tag_list: 'linux')
    
    tagged_with_list = User.tagged_with('linux')
    tagged_with_list.include?(@user).should be_true
    tagged_with_list.include?(user_2).should be_true
  end

  it "should return all_tags per Model class" do
    User.create(name: 'ubuntu', tag_list: 'linux')

    expected_tag_list = [ 
      {:name => "free software",  :count => 1},
      {:name => "linux",          :count => 2},
      {:name => "tucuman",        :count => 1}
    ]
    User.all_tags.should == expected_tag_list
  end

end

describe "A Taggable model with scope" do

  before(:each) do 
    @organization_1 = Organization.create(name: 'Qualica')
    @user_1 = @organization_1.users.create(name: 'User1', tag_list: "ubuntu, linux, tucuman")
    @user_2 = @organization_1.users.create(name: 'User2', tag_list: "ubuntu, linux, tucuman")

    @organization_2 = Organization.create(name: 'Microsoft')
    @user_3 = @organization_2.users.create(name: 'User3', tag_list: 'microsoft, windows, tucuman')
    @user_4 = @organization_2.users.create(name: 'User4', tag_list: 'ubuntu, linux, tucuman')
  end

  it "should return scoped tags when passing one option" do 
    results = User.all_tags(organization_id: @organization_1.id)
    results.empty?.should be_false

    results.include?( {:name => "linux", :count => 2 } ).should be_true
    results.include?( {:name => "ubuntu", :count => 2 } ).should be_true
    results.include?( {:name => "tucuman", :count => 2 } ).should be_true
    
    results = User.all_tags(organization_id: @organization_2.id)
    results.empty?.should be_false
    results.include?( {:name =>"linux", :count => 1 } ).should be_true
    results.include?( {:name => "microsoft", :count => 1 } ).should be_true
    results.include?( {:name => "windows", :count => 1 } ).should be_true
    results.include?( {:name => "tucuman", :count => 2 } ).should be_true
  end

  it "should return scoped tags when passing more than one option" do
    results = User.all_tags(organization_id: @organization_1.id, name: @user_1.name)
    
    results.empty?.should be_false
    results.include?( {:name => "linux", :count => 1 } ).should be_true
    results.include?( {:name => "ubuntu", :count => 1 } ).should be_true
    results.include?( {:name => "tucuman", :count => 1 } ).should be_true
  end

  it "should return scoped tags when calling deprecated scoped_tags method" do 
    results = User.all_tags(organization_id: @organization_1.id)
    
    results.empty?.should be_false
    results.include?( {:name => "linux", :count => 2 } ).should be_true
    results.include?( {:name => "ubuntu", :count => 2 } ).should be_true
    results.include?( {:name => "tucuman", :count => 2 } ).should be_true
  end

end
