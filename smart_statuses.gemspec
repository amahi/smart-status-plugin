$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "smart_statuses/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "smart_statuses"
  s.version     = SmartStatus::VERSION
  s.authors     = "Sukhbir Singh"
  s.email       = ["sukhbir947@gmail.com"]
  s.homepage    = "https://www.amahi.org/apps/smart-status"
  s.license     = "AGPLv3"
  s.summary     = %{Monitor the S.M.A.R.T. status of your drives with this Amahi plugin.}
  s.description = %{This is an Amahi 11 platform plugin that uses S.M.A.R.T. tools to monitor the status of all drives in an Amahi server.}

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end

