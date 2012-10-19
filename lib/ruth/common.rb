require 'tmpdir'

module Common
  def Common.dot_ruth
    if ENV['TRAVIS']
      File.join(Dir.tmpdir, ".ruth")
    else
      File.join(ENV['home'], ".ruth")
    end
  end
end