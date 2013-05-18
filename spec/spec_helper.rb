require 'mongoid'
require 'mongoid-simple-tags'

Mongoid.load!("mongoid.yml", :test)

RSpec.configure do |config|
  config.after(:each) do
    Mongoid::Config.purge!
  end
end