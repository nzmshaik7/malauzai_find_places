require 'uri'
require 'json'
require 'httparty'

module MalauzaiFindPlaces
  class Request
    include ::HTTParty

    attr_accessor :response
    format :json

    def initialize(request_url, parameters)

      url = URI.parse(request_url)
      @response = self.class.get(url, :query => parameters)
      @response.parsed_response

    end

    def parsed_response
      if(@response.code >= 300 && @response.code < 400)
        return @response.headers["location"]
      end

      if(@response.code >= 500 && @response.code < 600)
        raise APIConnectionError.new(@response)
      end

      case @response.parsed_response['status']
        when 'OK', 'ZERO_RESULTS'
          @response.parsed_response
        when 'OVER_QUERY_LIMIT'
          raise OverQueryLimitError.new(@response)
        when 'REQUEST_DENIED'
          raise RequestDeniedError.new(@response)
        when 'INVALID_REQUEST'
          raise InvalidRequestError.new(@response)
        when 'UNKNOWN_ERROR'
          raise UnknownError.new(@response)
        when 'NOT_FOUND'
          raise NotFoundError.new(@response)
      end
    end

  end
end
