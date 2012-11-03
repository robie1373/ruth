require 'digest/md5'

module Ruth
  class Hasher

    def md5(file_path)
      Digest::MD5.hexdigest(File.read(file_path))
    end
  end
end