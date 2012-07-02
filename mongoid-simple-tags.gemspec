# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "mongoid-simple-tags"
  s.version     = "0.0.6"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["chebyte"]
  s.email       = ["maurotorres@gmail.com"]
  s.homepage    = "https://github.com/chebyte/mongoid-simple-tags"
  s.summary     = %q{MongoID simple tags for RAILS}
  s.description = %q{basic and simple tagging system for mongoid using map-reduce function}

  s.rubyforge_project = "mongoid-simple-tags"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec", "~> 2.10.0"
  s.add_dependency "mongoid", "~> 2.4"
  s.add_dependency "bson_ext", "~> 1.5"  
end
