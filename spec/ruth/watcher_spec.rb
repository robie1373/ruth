require_relative '../spec_helper'

module Ruth
  describe Watcher do
    describe "#watch" do
      before(:each) do
        watched_file_list = Watched_file_getter.new.watched_files # [File.join(ENV['home'], ".ruth")]#
        @time_object = Time.now
        @notification = double("notification")
        @watcher = Watcher.new(:watched_file_list => watched_file_list, :time => @time_object, :notification => @notification)
        @file_to_change = File.join(ENV['home'], ".ruth", "watchme.txt")
        File.open(@file_to_change, 'w') { |f| f.write "This is the only line allowed in this file.\n"}
        @watcher.watch_with_listen(watched_file_list)
      end

      it "must signal when a file in its base has changed" do
        @notification.should_receive(:new).with(:file => [@file_to_change], :action => :modified, :time => @time_object).at_least(:once)
        @watcher.run
        File.open(@file_to_change, 'a') { |f| f.write "This should not be in this file.\n" }
        #FileUtils.touch @file_to_change
        @watcher.stop
      end

      it "must signal when a file in a subdir has changed" do
        file_to_change = File.join(ENV['home'], ".ruth", "interfolder", "newfile.txt" )
        @notification.should_receive(:new).with(:file => [@file_to_change], :action => :modified, :time => @time_object).at_least(:once)
        @watcher.run
        #File.open(file_to_change, 'a') { |f| f.write "This should not be in this file.\n" }
        FileUtils.touch file_to_change
        @watcher.stop
        File.unlink file_to_change
      end

    end
  end
end