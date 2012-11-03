module Ruth
  class Baseline
    def baseline(args)
      file_list    = args[:file_list]
      hasher       = args[:hasher]
      hashed_files = Hash.new
      file_list.each do |file|
        hashed_files[file] = hasher.md5(file)
      end
      hashed_files
    end
  end
end