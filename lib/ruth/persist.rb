module Ruth
  class Persist
    def persist(args)
      baseline = args[:baseline]
      File.open(File.join(Common.dot_ruth, "baseline.json"), 'a') { |file| file.write(baseline.to_json)}
    end
  end
end