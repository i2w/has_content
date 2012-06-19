$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "has_content/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "has_content"
  s.version     = HasContent::VERSION
  s.authors     = ["Ian White"]
  s.email       = ["ian.w.white@gmail.com"]
  s.homepage    = "http://github.com/i2w/has_content"
  s.summary     = "Simple wrapper for adding content via a polymorphic join for any object"
  s.description = "Simple wrapper for adding content via a polymorphic join for any object.  Version #{HasContent::VERSION}."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md", "CHANGELOG"]
  s.test_files = Dir["spec/**/*"]
  
  s.add_dependency "activerecord", ">=3.2"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", ">=2"
  s.add_development_dependency "sqlite3"
end
