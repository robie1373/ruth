require 'json'
require 'digest'
require 'tempfile'
require 'rb-fchange'
require_relative './watched_file_getter'

# The backend for this should be a REST API that will accept the posts of hashes
# in a db. It should serve up the baseline to the remote service and provide
# search for a hash to users.
module Ruth
  class Watcher

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
