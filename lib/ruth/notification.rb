module Ruth
  class Notification
    def initialize(args)
      @output = args[:destination]
    end

    def notify(args)
      filename = args[:file]
      action   = args[:action]
      time     = args[:time]
      @output.puts "#{filename} was #{action} at #{time}"
    end

  end
end