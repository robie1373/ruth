require_relative '../spec_helper'

module Ruth
  describe Baseline do
    describe "#baseline" do
      before(:each) do
        @baseline = Baseline.new
      end
      it "should return a hash of file paths => hashes for list of files passed in" do
        pending "think about how this should look"
        #@baseline(@file_list).should ==
      end
    end
  end
end
