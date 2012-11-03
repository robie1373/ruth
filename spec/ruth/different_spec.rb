require_relative '../spec_helper'

module Ruth
  include Set_up_methods
  describe Different do
    before(:all) do
      Set_up_methods.keep_house
    end

    after(:all) do
      Housekeeper.new(:mode => :test).clean_up_ruth
    end

    it "should tell me if the input file path has changed since baseline" do
      file_path = File.join(Common.dot_ruth, "watchme.txt")
      baseline = Baseline.new.baseline(:file_list => [file_path], :hasher => Hasher.new)

      File.open(file_path, 'a') { |f| f.write "This is a change" }
      Different.new(:baseline => baseline).different?(file_path).should == true
    end
  end
end