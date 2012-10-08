module Ruth
  class Watched_file_getter
    def initialize
      Struct.new("Config", :watch_list, :ignore_list)
    end

    def config
      #noinspection RubyArgCount
      Struct::Config.new(parse_configs(read_config_file(watch_file)), parse_configs(read_config_file(ignore_file)))
    end

    def watched_files(config=config)
      watched_files_array = []
      config.watch_list.each do |entry|
        watched_files_array << glob_files(entry)
      end
      watched_files_array.flatten!
      watched_files_array - ignore_files(config)
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

    def ignore_files(config)
      ignore_files_array = []
      config.ignore_list.each do |entry|
        ignore_files_array << glob_files(entry)
      end
      ignore_files_array.flatten!
      ignore_files_array
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