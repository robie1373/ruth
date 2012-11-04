require_relative '../spec_helper'

module Ruth
  describe Notification do
    before(:each) do
      @time_object      = Time.now
      @file_path = File.join(Common.dot_ruth, "watchme.txt")
      @output = StringIO.new("")
      @notification = Notification.new
    end

    describe "#notify" do
      it "must put the notification to the terminal if so desired" do
        @notification.notify(:destination => @output, :file => @file_path, :action => :modified, :time => @time_object)
        @output.string.should match(/#{@file_path}.*#{@time_object}/)
      end
    end

  end
end