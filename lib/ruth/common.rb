require 'tmpdir'

module Common
  def Common.dot_ruth
    if  RUBY_PLATFORM =~ /(win32|w32)/i
      File.join(ENV['home'], ".ruth")
    else
      File.join(ENV['HOME'], ".ruth")
    end
  end

  def Common.log_file
    File.join(Common.dot_ruth, "alerts.log")
  end

end