require 'simplecov'
SimpleCov.start

require 'rspec'
require 'win32console' if RUBY_PLATFORM =~ /(win32|w32)/
require 'bundler'

require 'ruth'

module Ruth
  include Common
end
