require_relative '../spec_helper'

module Ruth
  describe Housekeeper do

    before(:each) do
      @housekeeper = Housekeeper.new(:mode => :test)
      @dot_ruth = Common.dot_ruth
      FileUtils.rm_rf @dot_ruth
      @dir_contents= [File.join(@dot_ruth, "alerts.log"),
                      File.join(@dot_ruth, "ignore_file.txt"),
                      File.join(@dot_ruth, "interfolder", "afile.txt"),
                      File.join(@dot_ruth, "interfolder", "anotherfile.txt"),
                      File.join(@dot_ruth, "interfolder", "bottomfolder", "thatfile.txt"),
                      File.join(@dot_ruth, "interfolder", "bottomfolder", "thisfile.txt"),
                      File.join(@dot_ruth, "watchme.txt"),
                      File.join(@dot_ruth, "watch_file.txt")]
    end

    after(:each) do
      begin
        FileUtils.rm_rf @dot_ruth
      rescue
        #p "no .ruth"
      end
    end

    describe "#init_ruth" do
      # set up .ruth etc.
      it "should start with no .ruth dir" do
        File.directory?(@dot_ruth).should be_false, "Expected .ruth not to be there but it was."
      end

      it "should create .ruth" do
        @housekeeper.init_ruth
        File.directory?(@dot_ruth).should be_true, "expected .ruth to be created but it was not."
      end

      it "should create files in .ruth" do
        @housekeeper.init_ruth
        ["alerts.log", "watch_file.txt", "ignore_file.txt", "watchme.txt", "dullfile.pst"].each do |file|
          File.file?(File.join(@dot_ruth, file)).should be_true, "expected #{file} to be there but it is missing."
        end
      end

      it "should create subdirectories in .ruth" do
        @housekeeper.init_ruth
        File.directory?(File.join(@dot_ruth, "interfolder")).should be_true, "Expected interfolder to be there but it wasnt."
      end

      it "should create files in subdirectories" do
        @housekeeper.init_ruth
        ["afile.txt", "anotherfile.txt"].each do |file|
          file = File.join(@dot_ruth, "interfolder", file)
          File.file?(file).should be_true, "expected #{file} to exist but it does not."
        end
      end

      it "should make even deeper dirs" do
        @housekeeper.init_ruth
        File.directory?(File.join(@dot_ruth, "interfolder", "bottomfolder")).should be_true, "Expected bottom folder to be there but it was not."
      end

      it "should make the bottom files too" do
        @housekeeper.init_ruth
        ["thatfile.txt", "thisfile.txt"].each do |file|
          file = File.join(@dot_ruth, "interfolder", "bottomfolder", file)
          File.file?(file).should be_true, "expected #{file} to be there but it wasn't"
        end
      end

      it "should ensure the watch_file.txt has a proper skeleton" do
        @housekeeper.init_ruth
        skeleton = %Q{#####
##
## This file contains the list of files and directories you want to watch
## for changes.
## Example:
## C:\\Users\\ruth
## C:\\Users\\ruth\\secret.txt
## C:\\Users\\ruth\\*.doc
##
############

#{@dot_ruth}}
        (File.open(File.join(@dot_ruth, "watch_file.txt")) { |f| f.read }).strip.should == skeleton.strip
      end


      it "should ensure the ignore_file.txt has a proper skeleton" do
        @housekeeper.init_ruth
        skeleton = %Q{#####
##
## This file contains the list of files and directories you do not want to watch
## for changes.
## Example:
## C:\\Users\\ruth
## C:\\Users\\ruth\\secret.txt
## C:\\Users\\ruth\\*.doc
##
############

#{File.join(@dot_ruth, "dullfile.pst")}\n#{File.join(@dot_ruth, "interfolder", "bottomfolder")}}

        (File.open(File.join(@dot_ruth, "ignore_file.txt")) { |f| f.read }).strip.should == skeleton.strip

      end
    end

    describe "#clean_up_ruth" do
      # get rid of .ruth etc.
      it "should unlink the .ruth directory leaving a clean hole" do
        Dir.mkdir @dot_ruth
        Dir.mkdir(File.join(@dot_ruth, "interfolder"))
        @housekeeper.clean_up_ruth
        File.directory?(@dot_ruth).should be_false, "Expected .ruth and all subdirs to be deleted but they were not."
      end
    end

    describe "#dir_contents" do
      # return the skeleton files.
      it "should return an array of files." do
        @housekeeper.dir_contents.length.should == @dir_contents.length
      end
    end

  end
end
