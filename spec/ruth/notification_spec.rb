require_relative '../spec_helper'

module Ruth
  describe Notification do
    before(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
    end

    before(:each) do
      @time_object      = Time.now
      @file_path = File.join(Common.dot_ruth, "watchme.txt")
      @output = StringIO.new("")
      @notification = Notification.new(:destination => @output)
    end

    describe "#notify" do
      it "must put the notification to the terminal if so desired" do
        @notification.notify(:file => @file_path, :action => :modified, :time => @time_object)
        @output.string.should match %r{#{@file_path}.*#{@time_object}}
      end
    end

  end
end