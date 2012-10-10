module Ruth
  class Housekeeper

    def dir_contents
      ["#{ENV['home']}/.ruth/alerts.log",
       "#{ENV['home']}/.ruth/ignore_file.txt",
       "#{ENV['home']}/.ruth/interfolder/afile.txt",
       "#{ENV['home']}/.ruth/interfolder/anotherfile.txt",
       "#{ENV['home']}/.ruth/interfolder/bottomfolder/thatfile.txt",
       "#{ENV['home']}/.ruth/interfolder/bottomfolder/thisfile.txt",
       "#{ENV['home']}/.ruth/watchme.txt",
       "#{ENV['home']}/.ruth/watch_file.txt"]
    end

    @dot_ruth = File.join(ENV['home'], ".ruth")

    def init_ruth
      ignore_file_text = \
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

File.join(@dot_ruth, "dullfile.pst"
File.join(@dot_ruth, "interfolder", "bottomfolder")
}
      watchme_file_text = "This is the only text allowed in this file."
      watch_file_text = \
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

@dot_ruth
}
      unless File.directory?(@dot_ruth) do
        Dir.mkdir @dot_ruth
        {"alerts.log" => "", "ignore_file.txt" => ignore_file_text, "watchme.txt" => watchme_file_text, "watch_file.txt" => watch_file_text, "dullfile.pst" => ""}.each_pair do |file, contents|
          File.open(File.join(@dot_ruth, file), 'w') { |f| f.write contents }
        end

        Dir.mkdir(File.join(@ruth, "interfolder"))
        {"afile.txt" => "", "anotherfile.txt" => ""}.each_pair do |file, contents|
          File.open(File.join(@dot_ruth, "interfolder", file), 'w') { |f| f.write contents }
        end

        Dir.mkdir(File.join(@ruth, "interfolder", "bottomfolder"))
        {"thatfile.txt" => "", "thisfile.txt" => ""}.each_pair do |file, contents|
          File.open(File.join(@dot_ruth, "interfolder", "bottomfolder", file), 'w') { |f| f.write contents }
        end
      end
      end
    end

    def clean_up_ruth

    end

  end
end