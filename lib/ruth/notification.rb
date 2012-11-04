module Ruth
  class Notification
    def notify(args)
      output = args[:destination]
      filename = args[:file]
      action = args[:action]
      time = args[:time]
      output.puts "#{filename} was #{action} at #{time}"
    end

  end
end