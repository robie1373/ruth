require 'simplecov'
SimpleCov.start

require 'rspec'
require 'win32console' if RUBY_PLATFORM =~ /(win32|w32)/
require 'bundler'

require 'ruth'

module Ruth
  include Common

  module Set_up_methods
    def Set_up_methods.keep_house
      @housekeeper = Housekeeper.new(:mode => :test)
      @housekeeper.clean_up_ruth
      begin
        @housekeeper.init_ruth
      rescue Errno::EEXIST
        p "Housekeeping failed."
      end
    end
  end

end
