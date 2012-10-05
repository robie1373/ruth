require 'json'
require 'digest'
require 'tempfile'
require 'rb-fchange'

# The backend for this should be a REST API that will accept the posts of hashes
# in a db. It should serve up the baseline to the remote service and provide
# search for a hash to users.
module Ruth
  class Watcher
    def initialize
      @watch_file = watch_file
      @ignore_file = ignore_file
      @watch_list = watch_list
    end

    def first_run
      if File.file? watch_file
      else
      end
    end

    def watch_mode
      notifier = FChange::Notifier.new
      notifier.watch(@watch_list, :all_events, :recursive) do |event|
        p Time.now.utc
      end

      Signal.trap('INT') do
        p "Game over...",
          notifier.stop
        abort("\n")
      end

      notifier.run
    end

    private ##### Private methods line ########
    def watch_list
      # pseudo code:
      (File.readlines @watch_file) - (File.readlines @ignore_file)
    end

    def watch_file
      File.open("File.join(ENV['home'], 'watch_file.txt')")
    end

    def ignore_file
      File.open("File.join(ENV['home'], 'ignore_file.txt')")
    end

    def hash_the_file(filename)
      if File.file?(filename)
        p filename
        begin
          @file_hashes[filename] = Digest::SHA256.file(filename).hexdigest
          puts "hashes to: #{@file_hashes[filename]}\n\n"
        rescue Errno::EACCES
          puts "File busy. Moving on."
        end
      end
    end

  end # Watcher

end # Module
