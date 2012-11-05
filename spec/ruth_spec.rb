require_relative './spec_helper'

module Ruth
  include Set_up_methods
  describe Main do
    before(:each) do
      @housekeeper  = Housekeeper.new(:mode => :test)
      @start_up_log = Common.start_up_log
      @output = StringIO.new("")
      @notification = Notification.new(:destination => @output)
    end

    after(:each) do
      @housekeeper.clean_up_ruth
    end

    after(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
    end

    it "should create .ruth if it doesn't exist" do
      @housekeeper.clean_up_ruth
      Main.new(:time => Time.new, :notification => @notification).startup
      File.directory?(Common.dot_ruth).should == true
    end

    describe "when .ruth already exists" do
      before(:each) do
        @housekeeper.init_ruth
        @time = Time.new
      end

      it "should leave .ruth alone if it does exist" do
        Main.new(:time => @time, :notification => @notification).startup
        File.read(@start_up_log).should include "Ruth starting at #{@time}"
      end

      it "should persist a baseline" do
        main = Main.new(:time => @time, :notification => @notification)
        main.startup
        watched_files       = Watched_file_getter.new.watched_files
        known_baseline_file = Baseline.new.baseline(:file_list => watched_files, :hasher => Hasher.new).to_json
        File.read(Common.baseline_file).should == known_baseline_file
      end

      it "should start putting changes to the terminal when run" do
        pending "Why doesn't this work?"
        file_to_change = File.join(Common.dot_ruth, "watchme.txt")
        main = Main.new(:time => @time, :notification => @notification)
        main.startup
        File.open(file_to_change, 'a') { |f| f.write "\nThis is a change" }
        File.open(File.join(Common.dot_ruth, "oogy.boogy"), 'w') { |f| f.write "ooogy oogy oogy." }
        p "\n\noutput is:\n\n #{@output.string}"
        p @output.string
        @output.string.should match %r{#{file_to_change}}
        main.stop
      end

    end
  end
end