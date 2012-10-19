#require_relative 'common'
module Ruth
  class Watched_file_getter
    include Common
    def initialize
      Struct.new("Config", :watch_list, :ignore_list)
      #noinspection RubyArgCount
      @config = Struct::Config.new(parse_configs(read_config_file(watch_file)), parse_configs(read_config_file(ignore_file)))
    end

    def config
      @config
    end

    def watched_files(config=config)
      watched_files_array = []
      config.watch_list.each.map { |entry| watched_files_array << glob_files(entry) }
      watched_files_array.flatten! - ignore_files(config)
    end

    def glob_files(dirname)
      if File.file? dirname
        give_back = dirname
      else
        give_back = []
        Dir.glob(File.join(dirname, "**/*")).map { |path| give_back << path if File.file? path }
      end
      give_back
    end

    def ignore_files(config)
      ignore_files_array = []
      config.ignore_list.map { |entry| ignore_files_array << glob_files(entry) }
      ignore_files_array.flatten!
      ignore_files_array
    end

    private
    def read_config_file(file)
      File.open(file) { |f| f.readlines }
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
      File.join(Common.dot_ruth, "watch_file.txt")
    end

    def ignore_file
      File.join(Common.dot_ruth, "ignore_file.txt")
    end
  end
end