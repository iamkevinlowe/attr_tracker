$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "attr_tracker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "attr_tracker"
  s.version     = AttrTracker::VERSION
  s.authors     = ["Kevin Lowe"]
  s.email       = ["iamkevinlowe@gmail.com"]
  s.homepage    = "http://github.com/iamkevinlowe/attr_tracker"
  s.summary     = "Track changes."
  s.description = "Allows the changes to an attribute to be tracked."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
end
