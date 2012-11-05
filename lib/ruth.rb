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
      @time         = args[:time] #|| Time.new
      @notification = args[:notification] || Notification.new(:destination => STDOUT)
    end

    def startup
      begin
        write_dot_ruth_files
        Persist.new.persist(:baseline => baseline)
        @watcher = Watcher.new(:logger => Logger.new, :watched_file_list => files_to_watch, :time => time, :notification => @notification, :different => Different.new(:baseline => baseline))
        @watcher.watch
        @watcher.run
      rescue SystemExit, Interrupt
        puts "\nExiting Ruth."
        log(:destination => startup_log, :message => "Ruth exiting at #{time}")
        @watcher.stop
      end
    end

    def stop
      @watcher.stop
    end

    private
    #def watch
    #  Watcher.new(:watched_file_list => files_to_watch, :time => @time, :notification => @notification, :different => Different.new(:baseline => baseline))
    #end

    def baseline
      Baseline.new.baseline(:file_list => files_to_watch, :hasher => Hasher.new)
    end


    def files_to_watch
      #[File.join(Common.dot_ruth, "demo_dir")]
      Watched_file_getter.new.watched_files
    end

    def write_dot_ruth_files
      if exists? Common.dot_ruth
        log(:destination => startup_log, :message => "Ruth starting at #{time}")
      else
        if $0 == "bin/ruth"
          housekeeper = Housekeeper.new(:mode => :production)
        else
          housekeeper = Housekeeper.new(:mode => :test)
        end
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
      if @time
        @time
      else
        Time.now
      end
    end
  end
end
