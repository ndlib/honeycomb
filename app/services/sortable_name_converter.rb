class SortableNameConverter
  attr_reader :original_name

  def self.convert(name)
    new(name).converted_name
  end

  def initialize(original_name)
    @original_name = original_name
  end

  def converted_name
    if @converted_name.nil?
      @converted_name = original_name.to_s.strip
      @converted_name = SortAlphabetical.normalize(@converted_name)
      @converted_name.downcase!
      @converted_name.gsub!(/['"`“‘’ʻ()]+/, "")
      @converted_name.sub!(/^(the|a|an)\s+/i, "")
      @converted_name.strip!
    end
    @converted_name
  end
end
