module Common
  def Common.dot_ruth
    if ENV['TRAVIS'] == true
      File.join(ENV['HOME'], ".ruth")
    else
      File.join(ENV['home'], ".ruth")
    end
  end
end