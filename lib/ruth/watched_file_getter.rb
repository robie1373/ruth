module Ruth
  class Watched_file_getter
    def initialize
      @watched_files_array = []
    end

    def config
      Struct.new("Config", :watch_list, :ignore_list)
      Struct::Config.new(parse_configs(read_config_file(watch_file)),
                         parse_configs(read_config_file(ignore_file)))
    end

    def watched_files(config)
      config.watch_list.each do |entry|
        @watched_files_array << glob_files(entry)
      end
      @watched_files_array.flatten!
    end


    def glob_files(dirname)
      # example below
      # Dir.glob(File.join(ENV['home'], "**/*.txt"))
      if File.file? dirname
        give_back = dirname
      else
        give_back = []
        Dir.glob(File.join(dirname, "**/*")) do |path|
          give_back << path if File.file? path
        end
      end
      give_back
    end

    private ##### Private methods line ########
    def read_config_file(file)
      file.readlines
    end

    def parse_configs(array)
      array.map! do |line|
        line.chomp
      end.delete_if do |line|
        line == ""
      end.delete_if do |line|
        line.match '^#'
      end
      array.map! do |path|
        File.join(path.split('\\'))
      end
    end

    def watch_file
      File.open File.join(ENV['home'], ".ruth", "watch_file.txt")
    end

    def ignore_file
      File.open File.join(ENV['home'], ".ruth", "ignore_file.txt")
    end
  end
end