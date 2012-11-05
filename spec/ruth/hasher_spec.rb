require_relative '../spec_helper'

module Ruth

  describe Hasher do
    include Set_up_methods
    before(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
      Set_up_methods.keep_house
      @path = File.join(Common.dot_ruth, "watch_file.txt")
      @data = File.read @path
    end

    after(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
    end

    describe "#md5" do
      before(:each) do
        @hasher  = Hasher.new
        #@md5hash = OpenSSL::Digest::MD5.new
      end

      it "should return the md5 hash of the file path passed in" do
        @hasher.md5(@path).should == Digest::MD5.hexdigest(@data)
      end
    end

    #describe "#sha1" do
    #  pending "maybe get rid of this"
    #  before (:each) do
    #    @hasher   = Hasher.new
    #    #@sha1hash = OpenSSL::Digest::SHA1.new
    #  end

    #  it "should return the sha1 hash of the file path passed in" do
    #    @hasher.sha1(@path).should == @sha1hash.digest(@data)
    #  end
    #end


  end
end