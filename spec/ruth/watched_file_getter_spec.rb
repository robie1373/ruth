require_relative '../spec_helper'

module Ruth
  describe Watched_file_getter do
    before(:all) do
      def keep_house
        @housekeeper = Housekeeper.new(:mode => :test)
        @housekeeper.clean_up_ruth
        begin
          @housekeeper.init_ruth
        rescue Errno::EEXIST
        end
      end
      keep_house
    end

    before(:each) do
      @watched_file_getter = Watched_file_getter.new
    end

    #describe "#read_config_file" do
    #  it "must return an array of the file contents" do
    #    @watched_file_getter.read_config_file(@watch_file).should be_an_instance_of Array
    #  end
    #
    #  it "must have a length > 0" do
    #    @watched_file_getter.read_config_file(@watch_file).length.should_not == 0
    #  end
    #
    #  it "must match the test watch_file" do
    #    @watched_file_getter.read_config_file(@watch_file).should == ["#######################################\n",
    #                                                       "## This file contains the list of files and directories you want to watch\n",
    #                                                       "## for changes.\n", "##\n", "## Example:\n",
    #                                                       "## C:/Users/ruth\n", "## C:/Users/ruth/secret.txt\n",
    #                                                       "## C:/Users/ruth/*.doc\n", "##\n",
    #                                                       "########################################\n", "\n", "C:\\Users\\rlutsey\n"]
    #  end
    #end
    #
    #describe "#parse_configs" do
    #  it "must return an array of paths" do
    #    raw_array = @watched_file_getter.read_config_file(@watch_file)
    #    @watched_file_getter.parse_configs(raw_array).first.should == "#{Common.dot_ruth}"
    #  end
    #end

    describe "#config" do
      it "must read the watch file" do
        @watched_file_getter.config.watch_list.first.should == "#{Common.dot_ruth}"
      end

      it "must read the ignore file" do
        @watched_file_getter.config.ignore_list.first.should == "#{Common.dot_ruth}/dullfile.pst"
      end
    end

    describe "#glob_files" do
      before(:each) do
        @ruth_dir = Common.dot_ruth
      end

      it "returns an array of files in a directory" do
        @watched_file_getter.glob_files(Common.dot_ruth).should be_an_instance_of Array
      end

      it "returns the files in the directory" do
        @housekeeper.dir_contents.each do |file|
          @watched_file_getter.glob_files(@ruth_dir).include?(file).should be_true, "expected dir_contents to include #{file} but it does not"
        end
      end

      it "returns the filepath if a filepath is passed in" do
        real_file = File.join(Common.dot_ruth, "watch_file.txt")
        @watched_file_getter.glob_files(real_file).should == File.join(@ruth_dir, "watch_file.txt")
      end

      describe "#glob_files" do
        it "must not contain any directories" do
          @watched_file_getter.glob_files(@ruth_dir).each do |path|
            File.directory?(path).should_not == true
          end
        end
      end

    end

    describe "#ingore_files" do
      before(:each) do
        @watched_file_getter = Watched_file_getter.new
        @config = @watched_file_getter.config
      end

      it "must be an array" do
        @watched_file_getter.ignore_files(@config).should be_an_instance_of Array
      end

      it "must contain the ignored files" do
        ignored_files = ["#{Common.dot_ruth}/interfolder/bottomfolder/thatfile.txt", "#{Common.dot_ruth}/interfolder/bottomfolder/thisfile.txt"]
        ignored_files.each do |file|
          @watched_file_getter.ignore_files(@config).include?(file).should == true
        end
      end
    end

    describe "#watched_files" do
      before(:each) do
        @watched_file_getter = Watched_file_getter.new
        @config = @watched_file_getter.config
      end

      it "must be an array" do
        @watched_file_getter.watched_files(@config).should be_an_instance_of Array
      end

      it "must have at least one file" do
        @watched_file_getter.watched_files(@config).length.should_not == 0
      end

      it "must contain only real files" do
        @watched_file_getter.watched_files(@config).each do |watchlist_entry|
          File.file?(watchlist_entry).should == true
        end
      end

      it "must not contain files under ignored_files.txt" do
        @watched_file_getter.watched_files(@config).each do |watchlist_entry|
          watchlist_entry.should_not == "#{Common.dot_ruth}/dullfile.pst"
        end
      end

      it "must not contain files in subdirs under ignored_files.txt" do
        ignored_files = %w(#{Common.dot_ruth}/interfolder/bottomfolder/thatfile.txt
                          #{Common.dot_ruth}/interfolder/bottomfolder/thisfile.txt)
        @watched_file_getter.watched_files(@config).each do |watchlist_entry|
          ignored_files.each do |ig_file|
            watchlist_entry.should_not == ig_file
          end
        end
      end
    end


  end
end