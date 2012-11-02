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

    describe "#md5" do
      before(:each) do
        @hasher  = Hasher.new
        @md5hash = OpenSSL::Digest::MD5.new
      end

      it "should return the md5 hash of the file path passed in" do
        @hasher.md5(@path).should == @md5hash.digest(@data)
      end
    end

    describe "#sha1" do
      before (:each) do
        @hasher = Hasher.new
        @sha1hash = OpenSSL::Digest::SHA1.new
      end

      it "should return the sha1 hash of the file path passed in" do
        @hasher.sha1(@path).should == @sha1hash.digest(@data)
      end
    end


  end
end