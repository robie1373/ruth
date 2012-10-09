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

    def is_this_right
      # This method teaches me how flipping mocks work. Grr. That was confusing.
      # When the real functionality of the class looks like this I will have won.
      @notification.new(:file => "#{ENV['home']}/.ruth/watchme.txt", :time => @time)
    end

    def watch
      notifier = FChange::Notifier.new
      #@watched_file_list.each do |file|
      #  if File.directory? file
      #    dir = File.dirname(file)
      #  else
      #    dir = file
      #  end
        notifier.watch(File.join(ENV['home'], ".ruth"), :all_events, :recursive) do | event |
        p event
        @notification.new(:file => "#{ENV['home']}/.ruth/watchme.txt", :time => @time)
      #end
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
