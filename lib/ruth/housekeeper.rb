require 'fileutils'
module Ruth
  class Housekeeper
    def initialize(args)
      @mode = args[:mode] || :production
    end

    def dir_contents
      [File.join(dot_ruth, "alerts.log"),
       File.join(dot_ruth, "ignore_file.txt"),
       File.join(dot_ruth, "interfolder", "afile.txt"),
       File.join(dot_ruth, "interfolder", "anotherfile.txt"),
       File.join(dot_ruth, "interfolder", "bottomfolder", "thatfile.txt"),
       File.join(dot_ruth, "interfolder", "bottomfolder", "thisfile.txt"),
       File.join(dot_ruth, "watchme.txt"),
       File.join(dot_ruth, "watch_file.txt")]
    end

    def dot_ruth
      File.join(ENV['home'], ".ruth")
    end

    def create_files(file_and_contents)
      file = file_and_contents[0]
      contents = file_and_contents[1]
      File.open(file, 'w') { |f| f.write contents }
    end

    def init_ruth
      Dir.mkdir dot_ruth
      {File.join(dot_ruth, "alerts.log") => "", File.join(dot_ruth, "watch_file.txt") => watch_file_text, File.join(dot_ruth, "ignore_file.txt") => ignore_file_text}.each do |file_and_contents|
        create_files(file_and_contents)
      end
      if @mode == :test
        {File.join(dot_ruth, "watchme.txt") => watchme_file_text, File.join(dot_ruth, "dullfile.pst") => ""}.each do |file_and_contents|
          create_files(file_and_contents)
        end

        path = File.join(dot_ruth, "interfolder")
        Dir.mkdir(path)
        {File.join(path, "afile.txt") => "", File.join(path, "anotherfile.txt") => ""}.each_pair do |file_and_contents|
          create_files file_and_contents
        end

        path = File.join(dot_ruth, "interfolder", "bottomfolder")
        Dir.mkdir path
        {File.join(path, "thatfile.txt") => "", File.join(path, "thisfile.txt") => ""}.each do |file_and_contents|
          create_files file_and_contents
        end
      end
    end

    def clean_up_ruth
      FileUtils.rm_rf dot_ruth
    end

    private
    def watchme_file_text
      "This is the only text allowed in this file."
    end

    def watch_file_text
      %Q{#####
##
## This file contains the list of files and directories you want to watch
## for changes.
## Example:
## C:\\Users\\ruth
## C:\\Users\\ruth\\secret.txt
## C:\\Users\\ruth\\*.doc
##
############

#{dot_ruth}
      }
    end

    def ignore_file_text
      %Q{#####
##
## This file contains the list of files and directories you do not want to watch
## for changes.
## Example:
## C:\\Users\\ruth
## C:\\Users\\ruth\\secret.txt
## C:\\Users\\ruth\\*.doc
##
############

#{File.join(dot_ruth, "dullfile.pst")}\n#{File.join(dot_ruth, "interfolder", "bottomfolder")}
      }
    end
  end
end