class GenerateTitleFromFilename
  attr_reader :filename

  def self.call(filename)
    new(filename).generate
  end

  def initialize(filename)
    @filename = filename
  end

  def generate
    ensure_string
    remove_extension
    add_spaces
    titleize

    filename
  end

  private

    def ensure_string
      @filename = filename.to_s
    end

    def remove_extension
      @filename = File.basename(filename, '.*')
    end

    def add_spaces
      @filename = filename.gsub('_', ' ')
    end

    def titleize
      @filename = filename.titleize
    end

end
