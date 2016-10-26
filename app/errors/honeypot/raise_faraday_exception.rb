require 'faraday'
require File.expand_path('../errors', __FILE__)

module Honeypot
  class RaiseFaradayException < Faraday::Response::Middleware
    def on_complete(response)
      unless response[:status] == 200
        raise Honeypot::InternalServerError, response.body
      end
    end
  end
end
