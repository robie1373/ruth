require 'json'
require 'digest'
require 'tempfile'
require 'rb-fchange'
require 'listen'
require_relative './watched_file_getter'
require_relative './notification'

module Ruth
  class Watcher
    def initialize(args)
      @watched_file_list = args[:watched_file_list]
      @time = args[:time] || Time
      @notification = args[:notification]
    end

    def watch_with_listen(what_to_watch)
      callback = Proc.new do |modified, added, removed|
        if modified.to_s.length > 0
          notification.new(:file => modified.to_s, :action => :modified, :time => time)
        elsif added.to_s.length > 0
          notification.new(:file => added.to_s, :action => :added, :time => time)
        elsif removed.to_s.length > 0
          notification.new(:file => removed.to_s, :action => :removed, :time => time)
        else
          raise "unknown file event occurred"
        end
      end

      what_to_watch.map! { |i| ensure_directory(:file => i) }
      @listener = Listen.to(*what_to_watch)
      @listener.change(&callback)
    end

    def run
      sleep 0.6
      #Thread.new { @listener.start(false) }
      @listener.start(false)
      sleep 0.6
    end

    def stop
      sleep 0.6
      @listener.stop
    end

    private
    def ensure_directory(args)
      if File.file? args[:file]
        File.dirname(args[:file])
      else
        args[:file]
      end
    end

    def watched_file_list
      @watched_file_list
    end

    def time
      @time
    end

    def notification
      @notification
    end


#
#    def hash_the_file(filename)
#      if File.file?(filename)
#        p filename
#        begin
#          @file_hashes[filename] = Digest::SHA256.file(filename).hexdigest
#          puts "hashes to: #{@file_hashes[filename]}\n\n"
#        rescue Errno::EACCES
#          puts "File busy. Moving on."
#        end
#      end
#    end
#def first_run
#  if File.file? watch_file
#  else
#  end
#end

#def watch_mode
#  notifier = FChange::Notifier.new
#  notifier.watch(@watch_list, :all_events, :recursive) do |event|
#    p Time.now.utc
#  end
#
#  Signal.trap('INT') do
#    p "Game over...",
#      notifier.stop
#    abort("\n")
#  end
#
#  notifier.run
#end
  end # Watcher
end # Module
