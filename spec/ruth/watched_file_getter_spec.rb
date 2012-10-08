require_relative '../spec_helper'

module Ruth
  describe Watched_file_getter do
    def setup
      @watched_file_getter = Watched_file_getter.new
      @watch_file = File.open(File.join(ENV['home'], ".ruth", "watch_file.txt"))
    end

    #describe "#read_config_file" do
    #  it "must return an array of the file contents" do
    #    @watched_file_getter.read_config_file(@watch_file).must_be_instance_of Array
    #  end
    #
    #  it "must have a length > 0" do
    #    @watched_file_getter.read_config_file(@watch_file).length.wont_equal 0
    #  end
    #
    #  it "must match the test watch_file" do
    #    @watched_file_getter.read_config_file(@watch_file).must_equal ["#######################################\n",
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
    #    @watched_file_getter.parse_configs(raw_array).first.must_equal "#{ENV['home']}"
    #  end
    #end

    describe "#config" do
      it "must read the watch file" do
        @watched_file_getter.config.watch_list.first.must_equal "#{ENV['home']}/.ruth"
      end

      it "must read the ignore file" do
        @watched_file_getter.config.ignore_list.first.must_equal "#{ENV['home']}/.ruth/dullfile.pst"
      end
    end

    describe "#glob_files" do
      it "returns an array of files in a directory" do
        @watched_file_getter.glob_files(ENV['home']).must_be_instance_of Array
      end

      it "returns the files in the directory" do
        dir_contents = ["#{ENV['home']}/.ruth/alerts.log",
                        "#{ENV['home']}/.ruth/ignore_file.txt",
                        "#{ENV['home']}/.ruth/interfolder/afile.txt",
                        "#{ENV['home']}/.ruth/interfolder/anotherfile.txt",
                        "#{ENV['home']}/.ruth/interfolder/bottomfolder/thatfile.txt",
                        "#{ENV['home']}/.ruth/interfolder/bottomfolder/thisfile.txt",
                        "#{ENV['home']}/.ruth/watchme.txt",
                        "#{ENV['home']}/.ruth/watch_file.txt"]
        ruth_dir = File.join(ENV['home'], ".ruth")
        dir_contents.each do |file|
        @watched_file_getter.glob_files(ruth_dir).include?(file).must_equal true
          end
      end

      it "returns the filepath if a filepath is passed in" do
        real_file = File.join(ENV['home'], ".ruth", "watch_file.txt")
        @watched_file_getter.glob_files(real_file).must_equal File.join(ENV['home'], ".ruth", "watch_file.txt")
      end
    end

    describe "#ingore_files" do
      def setup
        @watched_file_getter = Watched_file_getter.new
        @config = @watched_file_getter.config
      end

      it "must be an array" do
        @watched_file_getter.ignore_files(@config).must_be_instance_of Array
      end

      it "must contain the ignored files" do
        ignored_files = ["#{ENV['home']}/.ruth/interfolder/bottomfolder/thatfile.txt", "#{ENV['home']}/.ruth/interfolder/bottomfolder/thisfile.txt"]
        ignored_files.each do |file|
          @watched_file_getter.ignore_files(@config).include?(file).must_equal true
        end
      end
    end

    describe "#watched_files" do
      def setup
        @watched_file_getter = Watched_file_getter.new
        @config = @watched_file_getter.config
      end

      it "must be an array" do
        @watched_file_getter.watched_files(@config).must_be_instance_of Array
      end

      it "must have at least one file" do
        @watched_file_getter.watched_files(@config).length.wont_equal 0
      end

      it "must contain only real files" do
        @watched_file_getter.watched_files(@config).each do |watchlist_entry|
          File.file?(watchlist_entry).must_equal true
        end
      end

      it "must not contain files under ignored_files.txt" do
        @watched_file_getter.watched_files(@config).each do |watchlist_entry|
          watchlist_entry.wont_equal "#{ENV['home']}/.ruth/dullfile.pst"
        end
      end

      it "must not contain files in subdirs under ignored_files.txt" do
        ignored_files = %w(#{ENV['home']}/.ruth/interfolder/bottomfolder/thatfile.txt
                          #{ENV['home']}/.ruth/interfolder/bottomfolder/thisfile.txt)
        @watched_file_getter.watched_files(@config).each do |watchlist_entry|
          ignored_files.each do |ig_file|
            watchlist_entry.wont_equal ig_file
          end
        end
      end
    end


  end
end