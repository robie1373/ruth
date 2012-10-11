require 'json'
require 'digest'
require 'tempfile'
require 'rb-fchange'
require_relative './watched_file_getter'
require_relative './notification'

module Ruth
  class Watcher
    def initialize(args)
      @watched_file_list = args[:watched_file_list]
      @time = args[:time] || Time
      @notification = args[:notification]
    end

    def watch
      @notifier = FChange::Notifier.new
      @watched_file_list.each do |file|
        dir = ensure_directory(:file => file)
        @notifier.watch(dir.to_s, :all_events, :recursive) do |event|
          @notification.new(:file => event.watcher.path, :time => @time)
        end
      end
    end

    def run
      sleep 0.6
      Thread.new { @notifier.run }
      sleep 0.6
    end

    def stop
      sleep 0.6
      @notifier.stop
    end

    private
    def ensure_directory(args)
      if File.file? args[:file]
        File.dirname(args[:file])
      else
        args[:file]
      end
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
