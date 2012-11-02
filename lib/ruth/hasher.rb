require 'OpenSSL'

module Ruth
  class Hasher

    def md5(file_path)
      OpenSSL::Digest::MD5.new.digest(File.read(file_path))
    end

    def sha1(file_path)
      OpenSSL::Digest::SHA1.new.digest(File.read(file_path))
    end

  end
end