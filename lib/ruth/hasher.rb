require 'OpenSSL'

module Ruth
  class Hasher

    def md5(file)
      OpenSSL::Digest::MD5.new.digest(File.read(file))
    end

    def sha1(file)
      OpenSSL::Digest::SHA1.new.digest(File.read(file))
    end

  end
end