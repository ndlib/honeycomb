require 'addressable/uri'

class URIParser
  attr_reader :uri

  def initialize(uri)
    @uri = uri
  end

  def parse
    @parse ||= Addressable::URI.parse(uri)
  end

  def valid?
    begin
      return (parse.scheme.present? && parse.host.present?)

    rescue Addressable::URI::InvalidURIError
      puts 'rescue'
      return false
    end
    puts 'false?'
    false
  end

  def self.call(uri)
    parser = new(uri)
    parser.parse
  end

  def self.valid?(uri)
    parser = new(uri)
    parser.valid?
  end
end
