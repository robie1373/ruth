module Ruth
  class Persist
    def persist(args)
      baseline = args[:baseline]
      File.open(Common.baseline_file, 'a') { |file| file.write(baseline.to_json)}
    end
  end
end