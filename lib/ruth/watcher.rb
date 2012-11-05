require 'json'
require 'digest'
require 'tempfile'
require 'listen'

module Ruth
  class Watcher
    def initialize(args)
      @watched_file_list = args[:watched_file_list]
      @time              = args[:time] || Time
      @notification      = args[:notification]
      @logger            = args[:logger]
      @different         = args[:different]
    end

    def watch(what_to_watch=@watched_file_list)
      callback = detect_change_type
      what_to_watch.map! { |i| ensure_directory(:file => i) }
      @listener = Listen.to(*what_to_watch)
      @listener.change(&callback)
    end

    def run
      sleep 0.6
      if $0 == File.join("bin", "ruth")
        @listener.start
      else
        @listener.start(false)
      end
      sleep 0.6
    end

    def stop
      sleep 0.6
      @listener.stop
    end

    private
    def detect_change_type
      Proc.new do |modified, added, removed|
        if modified.length > 0
          if different?(modified)
            event = { :file => modified, :action => :modified, :time => time }
            notification.notify(event)
            @logger.log(event) if @logger
          end
        elsif added.length > 0
          event = { :file => added, :action => :added, :time => time }
          notification.notify(event)
          @logger.log(event) if @logger
        elsif removed.length > 0
          event = { :file => removed, :action => :removed, :time => time }
          notification.notify(event)
          @logger.log(event) if @logger
        else
          raise "unknown file event occurred"
        end
      end
    end

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

    def different?(modified)
      @changed = false
      modified.each do |file_path|
        if @different.different?(file_path)
          @changed = true
        end
      end
      @changed
    end

  end
end
