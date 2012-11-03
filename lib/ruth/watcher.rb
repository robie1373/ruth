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
      @baseline          = args[:baseline]
      @different         = args[:different]
    end

    def watch(what_to_watch)
      callback = detect_change_type
      what_to_watch.map! { |i| ensure_directory(:file => i) }
      @listener = Listen.to(*what_to_watch)
      @listener.change(&callback)
    end

    def run
      sleep 0.6
      @listener.start(false)
      sleep 0.6
    end

    def stop
      sleep 0.6
      @listener.stop
    end

    private
    def detect_change_type
      Proc.new do |modified, added, removed|
        p modified.length, added.length, removed.length
        if modified.length > 0
          notification.new(:file => modified, :action => :modified, :time => time) if different?(modified)
        elsif added.length > 0
          notification.new(:file => added, :action => :added, :time => time)
        elsif removed.length > 0
          notification.new(:file => removed, :action => :removed, :time => time)
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

    def baseline
      @baseline
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
