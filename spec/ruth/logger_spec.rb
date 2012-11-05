require_relative '../spec_helper'

module Ruth
  include Set_up_methods

  describe Logger do
    before(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
      Set_up_methods.keep_house
    end

    after(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
    end

    describe "#log" do
      it "should write the notification to alerts.log in dot_ruth" do
        time_object = Time.now
        file_path   = File.join(Common.dot_ruth, "watchme.txt")
        logger = Logger.new
        logger.log(:file => file_path, :action => :modified, :time => time_object)
        File.read(Common.log_file).should match %r{#{file_path}.*#{time_object}}
      end
    end
  end
end