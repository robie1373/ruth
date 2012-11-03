module Ruth
  class Different
    def initialize(args)
      @baseline = args[:baseline]
    end

    def different?(file_path)
      hasher = Hasher.new
      current = hasher.md5 file_path
      original = baseline_value(file_path)
      current != original
    end

    private
    def baseline_value(file_path)
      baseline[file_path]
    end

    def baseline
      @baseline
    end
  end
end