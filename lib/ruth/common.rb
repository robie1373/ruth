module Common
  def Common.dot_ruth
    if ENV['TRAVIS'] == true
      require 'tmpdir'
      File.join(Dir.tmpdir, ".ruth")
    else
      File.join(ENV['home'], ".ruth")
    end
  end
end