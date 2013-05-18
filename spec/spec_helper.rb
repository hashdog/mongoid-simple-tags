require 'mongoid'
require 'mongoid-simple-tags'
require 'coveralls'
Coveralls.wear!

Mongoid.load!("mongoid.yml", :test)

RSpec.configure do |config|
  config.after(:each) do
    Mongoid::Config.purge!
  end
end