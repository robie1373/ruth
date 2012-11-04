module Ruth
  class Logger
    def log(args)
      filename = args[:file]
      action = args[:action]
      time = args[:time]
      File.open(Common.log_file, 'a') { |f| f.write("#{filename} was #{action} at #{time}") }

    end
  end
end