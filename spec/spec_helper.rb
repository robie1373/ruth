require 'simplecov'
SimpleCov.start

module Ruth
  require 'rspec'
  #require 'turn'
  require 'win32console' if RUBY_PLATFORM =~ /(win32|w32)/
  require 'bundler'
  #require 'terminal-notifier-guard'

  require 'ruth'

end
