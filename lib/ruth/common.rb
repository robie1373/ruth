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

  def Common.start_up_log
    File.join(Common.dot_ruth, "start_up.log")
  end

  def Common.baseline_file
    File.join(Common.dot_ruth, "baseline.json")
  end

end