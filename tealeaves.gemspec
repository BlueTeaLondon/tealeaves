$:.push File.expand_path("../lib", __FILE__)
require "tealeaves/version"
require "date"

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Tealeaves::RUBY_VERSION}"
  s.required_rubygems_version = ">= 3.0.0"
  s.authors = ["thoughtbot"]

  s.description = <<~HERE
    Tealeaves is a base Rails project that you can upgrade. It is used by
    thoughtbot to get a jump start on a working app. Use Tealeaves if you're in a
    rush to build something amazing; don't use it if you like missing deadlines.
  HERE

  s.email = "support@thoughtbot.com"
  s.executables = ["tealeaves"]
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = Dir[".ruby-version", "bin/tealeaves", "{docs,lib,templates}/**/*", "LICENSE", "*.md"]
  s.homepage = "http://github.com/bluetealondon/tealeaves"
  s.license = "MIT"
  s.name = "tealeaves"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = "Generate a Rails app using thoughtbot's best practices."
  s.version = Tealeaves::VERSION

  s.add_dependency "parser", ">= 3.0"
  s.add_dependency "bundler", ">= 2.1"
  s.add_dependency "rails", Tealeaves::RAILS_VERSION

  s.add_development_dependency "pry"
  s.add_development_dependency "rspec", "~> 3.2"
  s.add_development_dependency "standard"
end
