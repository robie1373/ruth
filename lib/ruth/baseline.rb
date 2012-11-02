module Ruth
  class Baseline
    def baseline(args)
      file_list    = args[:file_list]
      algorithm    = args[:algorithm]
      hasher       = args[:hasher]
      hashed_files = Hash.new
      file_list.each do |file|
        if algorithm == :md5
          hashed_files[file] = hasher.md5(file)
        elsif algorithm == :sha1
          hashed_files[file] = hasher.sha1(file)
        else
          raise "unknown algorithm"
        end
      end
      hashed_files
    end
  end
end