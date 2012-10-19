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
        @watcher.watch(watched_file_list)
      end

      it "must signal when a file in its base has changed" do
        @notification.should_receive(:new)
        @watcher.run
        #File.open(@file_to_change, 'a') { |f| f.write "This should not be in this file.\n" }
        FileUtils.touch @file_to_change
        @watcher.stop
      end

      it "must signal when a file in a subdir has changed" do
        file_to_change = File.join(ENV['home'], ".ruth", "interfolder", "newfile.txt" )
        @notification.should_receive(:new)
        @watcher.run
        #File.open(file_to_change, 'a') { |f| f.write "This should not be in this file.\n" }
        FileUtils.touch file_to_change
        @watcher.stop
        File.unlink file_to_change
      end

      it "must include the change action and time in the notification" do
        @notification.should_receive(:new).with(:file => kind_of(Array), :action => :modified, :time => @time_object)
        @watcher.run
        #File.open(@file_to_change, 'a') { |f| f.write "This should not be in this file.\n" }
        FileUtils.touch @file_to_change
        @watcher.stop
      end

      it "must include the file paths that were changed in the notification" do
        @notification.should_receive(:new) do |args|
          args[:file].should include(@file_to_change)
        end
        @watcher.run
        #File.open(@file_to_change, 'a') { |f| f.write "This should not be in this file.\n" }
        FileUtils.touch @file_to_change
        @watcher.stop
      end

      it "must set :action => :added when a file is created" do
        file_to_add = File.join(ENV['home'], ".ruth", "added_during_test.txt")
        @notification.should_receive(:new) do |args|
          args[:action].should == :added
        end
        @watcher.run
        FileUtils.touch file_to_add
        @watcher.stop
        File.unlink file_to_add
      end

      it "must set :action => :removed when a file is deleted" do
        file_to_remove = File.join(ENV['home'], ".ruth", "removed_during_test.txt")
        FileUtils.touch file_to_remove
        @notification.should_receive(:new) do |args|
          args[:action].should == :removed
        end
        @watcher.run
        File.unlink file_to_remove
        @watcher.stop
      end

    end
  end
end