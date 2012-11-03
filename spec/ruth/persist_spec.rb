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
      File.readlines(file_path).should == ["{\"/Users/robie1373/.ruth/alerts.log\":\"d41d8cd98f00b204e9800998ecf8427e\",\"/Users/robie1373/.ruth/ignore_file.txt\":\"8ff405110cafe3ae6a339f0c62541987\",\"/Users/robie1373/.ruth/interfolder/afile.txt\":\"d41d8cd98f00b204e9800998ecf8427e\",\"/Users/robie1373/.ruth/interfolder/anotherfile.txt\":\"d41d8cd98f00b204e9800998ecf8427e\",\"/Users/robie1373/.ruth/interfolder/bottomfolder/thatfile.txt\":\"d41d8cd98f00b204e9800998ecf8427e\",\"/Users/robie1373/.ruth/interfolder/bottomfolder/thisfile.txt\":\"d41d8cd98f00b204e9800998ecf8427e\",\"/Users/robie1373/.ruth/watchme.txt\":\"a89819ab16028a5b02ef86e5d7954398\",\"/Users/robie1373/.ruth/watch_file.txt\":\"8f8bc1c534ed7f3cc0dec57f84623809\"}"]
    end
  end
end