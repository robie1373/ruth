require_relative './spec_helper'

module Ruth
  include Set_up_methods
  describe Main do
    before(:each) do
      @housekeeper = Housekeeper.new(:mode => :test)
      @start_up_log = Common.start_up_log
    end

    after(:each) do
      @housekeeper.clean_up_ruth
    end

    after(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
    end

    it "should create .ruth if it doesn't exist" do
      @housekeeper.clean_up_ruth
      Main.new(:time => Time.now).startup
      File.directory?(Common.dot_ruth).should == true
    end

    it "should leave .ruth alone if it does exist" do
      time = Time.now
      @housekeeper.init_ruth
      Main.new(:time => time).startup
      File.read(@start_up_log).should include "Ruth starting at #{time}"
    end

  end
end