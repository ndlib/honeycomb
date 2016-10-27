require 'faraday'

module Buzz
  class RaiseFaradayException < Faraday::Response::Middleware
    def on_complete(response)
      case response[:status]
      when 200
      when 422
        raise Buzz::UnprocessableEntity, response.body
      else
        raise Buzz::InternalServerError
      end
    end
  end
end
