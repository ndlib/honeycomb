class GenerateNameFromFilename
  DEFAULT_OPTIONS = {
    remove_extension: true,
    add_spaces: false,
    titleize: false
  }
  attr_reader :filename

  def self.call(filename, options = {})
    new(filename).generate(options)
  end

  def initialize(filename)
    @filename = filename
  end

  def generate(options = {})
    options = DEFAULT_OPTIONS.merge(options)
    ensure_string
    if options[:remove_extension]
      remove_extension
    end
    if options[:add_spaces]
      add_spaces
    end
    if options[:titleize]
      titleize
    end

    filename
  end

  private

  def ensure_string
    @filename = filename.to_s
  end

  def remove_extension
    @filename = File.basename(filename, ".*")
  end

  def add_spaces
    @filename = filename.gsub("_", " ")
  end

  def titleize
    @filename = filename.titleize
  end
end
