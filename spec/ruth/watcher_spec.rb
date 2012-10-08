require_relative '../spec_helper'

module Ruth
  describe Watcher do
    describe "#watch" do
      def setup
        watched_file_list = Watched_file_getter.new.watched_files
        @time_object = Time.now
        @notification = MiniTest::Mock.new
        @watcher = Watcher.new(:watched_file_list => watched_file_list, :time => @time_object, :notification => @notification)
        @file_to_change = File.join(ENV['home'], ".ruth", "watchme.txt")
        File.open(@file_to_change, 'w') { |f| f.write "This is the only line allowed in this file.\n"}
        @watcher.watch
      end

      it "must signal when a file has changed" do
        @notification.expect(:new, true, [:file => @file_to_change, :time => @time_object])
        File.open(@file_to_change, 'a') { |f| f.write "This should not be in this file.\n" }
        #@watcher.is_this_right
        @notification.verify
      end

    end
  end
end