require_relative '../spec_helper'

module Ruth

  describe Hasher do
    before(:all) do
      def keep_house
        @housekeeper = Housekeeper.new(:mode => :test)
        @housekeeper.clean_up_ruth
        begin
          @housekeeper.init_ruth
        rescue Errno::EEXIST
          p "Housekeeping failed."
        end
      end

      keep_house
      @path = File.join(Common.dot_ruth, "watch_file.txt")
      @data = File.read @path
    end

    after(:all) do
      @housekeeper.clean_up_ruth
    end

    it "should return the hash of the file passed in", :integration => true do
      pending "Integration"
    end

    it "should return a SHA hash or MD5 hash based on input", :integration => true do
      pending "Integration"
    end

    describe "#md5" do

      it "should return the md5 hash of the file passed in" do
        file = Test_file.new(:path => @path)
        file.md5.should == @md5hash.digest(@data)
      end
    end

    describe "#sha" do
      before(:each) do
        @sha256hash = OpenSSL::Digest::SHA256.new
      end

      it "should return the sha hash of the file passed in" do
        pending "todo"
        @path.sha.should == @sha256hash.digest(@data)
      end
    end

  end
end