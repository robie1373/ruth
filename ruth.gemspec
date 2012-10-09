# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruth/version'

Gem::Specification.new do |gem|
  gem.name = "ruth"
  gem.version = Ruth::VERSION
  gem.authors = ["Robie"]
  gem.email = ["robie1373@gmail.com"]
  gem.description = %q{Watches files and directories for changes to its hash. Back end for searching hashes.}
  gem.summary = %q{Watches files and directories in the watchlist. Ignores files and direcoties in the ignore list. Integrates with a restful backend to allow central storage, searching and alerting.}
  gem.homepage = ""

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rb-fsevent' if RUBY_PLATFORM =~ /darwin/i
  gem.add_development_dependency 'guard' if RUBY_PLATFORM =~ /darwin/i
  gem.add_development_dependency 'terminal-notifier-guard' if RUBY_PLATFORM =~ /darwin/i
  gem.add_development_dependency 'turn', '< 0.8.3' if RUBY_PLATFORM =~ /darwin/i
  gem.add_development_dependency 'win32console' if RUBY_PLATFORM =~ /(win32|w32)/
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'

  # specify run dependencies here
  gem.add_dependency 'bundler', "~>1.1"
  gem.add_dependency 'rake', '~>0.9.2'
  gem.add_dependency 'rb-fchange', '~>0.0.6'
end
