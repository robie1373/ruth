require 'OpenSSL'

module Ruth
  module Hasher
    def md5
      OpenSSL::Digest::MD5.new.digest(self)

    end

  end
end