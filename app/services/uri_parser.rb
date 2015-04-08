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
    valid = true
    begin
      valid = false if parse.scheme.blank? || parse.host.blank?
    rescue Addressable::URI::InvalidURIError => e
      valid = false
    end
    valid
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
