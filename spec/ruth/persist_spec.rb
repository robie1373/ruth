require_relative '../spec_helper'

module Ruth
  include Set_up_methods
  describe Persist do
    before(:all) do
      Set_up_methods.keep_house
    end

    after(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
    end

    it "should marshal the hash provided by baseline into a simple file on disk" do
      persist   = Persist.new
      file_path = File.join(Common.dot_ruth, "baseline.json")
      file_list = Housekeeper.new(:mode => :test).dir_contents
      baseline  = Baseline.new.baseline(:file_list => file_list, :algorithm => :md5, :hasher => Hasher.new)
      persist.persist(:baseline => baseline)
      def create_correct_hash(file_list)
        result = Hash.new
        file_list.each do |file|
          result[file] = Digest::MD5.hexdigest(File.read(file))
        end
        result
      end
      correct_result = [create_correct_hash(file_list).to_json]
      File.readlines(file_path).should == correct_result
    end
  end
end