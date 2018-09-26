# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "mongoid-simple-tags"
  s.version     = "0.1.3"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["chebyte"]
  s.email       = ["maurotorres@gmail.com"]
  s.homepage    = "https://github.com/chebyte/mongoid-simple-tags"
  s.summary     = %q{MongoID simple tags for RAILS}
  s.description = %q{basic and simple tagging system for mongoid using map-reduce function}

  s.rubyforge_project = "mongoid-simple-tags"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec", "~> 2.13.0"
  s.add_dependency "mongoid", ">= 3.0.3"
  s.add_dependency "json", "~> 2"

end
