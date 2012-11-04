require 'ruth/common'
require "ruth/version"
require "ruth/watcher"
require "ruth/housekeeper"
require "ruth/watched_file_getter"
require 'ruth/notification'
require 'ruth/hasher'
require 'ruth/baseline'
require 'ruth/persist'
require 'ruth/different'
require 'ruth/logger'

# The backend for this should be a REST API that will accept the posts of hashes
# in a db. It should serve up the baseline to the remote service and provide
# search for a hash to users.
module Ruth
  include Common
  class Main
    def initialize(args)
      @time = args[:time] || Time.now
    end

    def startup
      place_dot_ruth
    end

    private
    def place_dot_ruth
      if exists? Common.dot_ruth
        log(:destination => startup_log, :message => "Ruth starting at #{time}")
      else
        housekeeper = Housekeeper.new(:mode => :production)
        housekeeper.init_ruth
        log(:destination => startup_log, :message => "No .ruth detected. Creating now.")
      end
    end

    def exists?(path)
      File.file?(path) || File.directory?(path)
    end

    def log(args)
      destination = args[:destination]
      message     = "#{args[:message]}\n"
      File.open(destination, 'a') { |f| f.write message }
    end

    def startup_log
      Common.start_up_log
    end

    def time
      @time
    end
  end
end
