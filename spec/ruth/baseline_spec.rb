require_relative '../spec_helper'

module Ruth
  include Set_up_methods
  describe Baseline do
    def hash_files(file_list, hasher, algorithm)
      hashed_files = Hash.new
      file_list.each do |file|
        if algorithm == :md5
          hashed_files[file] = hasher.md5(file)
        elsif algorithm == :sha1
          hashed_files[file] = hasher.sha1(file)
        else
          raise "unknown algorithm"
        end
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
        @baseline.baseline(:file_list => @file_list, :algorithm => :md5, :hasher => Hasher.new).should == hash_files(@file_list, Hasher.new, :md5)
      end

      it "should return a hash of file paths => sha1 hashes for array of files passed in" do
        @baseline.baseline(:file_list => @file_list, :algorithm => :sha1, :hasher => Hasher.new).should == hash_files(@file_list, Hasher.new, :sha1)
      end
    end
  end
end
