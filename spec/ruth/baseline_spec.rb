require_relative '../spec_helper'

module Ruth
  include Set_up_methods
  describe Baseline do
    def hash_files(file_list, hasher)
      hashed_files = Hash.new
      file_list.each do |file|
        hashed_files[file] = hasher.md5(file)
      end
      hashed_files
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

      it "should return a hash of file paths => md5 hashes for array of files passed in" do
        @baseline.baseline(:file_list => @file_list, :algorithm => :md5, :hasher => Hasher.new).should == hash_files(@file_list, Hasher.new)
      end

    end
  end
end
