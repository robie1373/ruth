require_relative '../spec_helper'

module Ruth
  include Set_up_methods
  describe Baseline do
    def hash_files(file_list, hasher, algorithm)
      hashed_files = Hash.new
      file_list.map do |file|
        hashed_files[file] = hasher.md5(file) if algorithm == :md5
        hashed_files[file] = hasher.sha1(file) if algorithm == :sha1
      end
    end

    before(:all) do
      Set_up_methods.keep_house
    end

    after(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
    end

    describe "#baseline" do
      before(:each) do
        @baseline  = Baseline.new
        @file_list = Housekeeper.new(:mode => :test).dir_contents
      end

      it "should return a hash of file paths => hashes for list of files passed in" do
        pending "finish cleaning up set up stuff in helper module"
        @baseline.baseline(:file_list => @file_list, :algorithm => :md5).should == hash_files(@file_list, Hasher.new, :md5)
      end
    end
  end
end
