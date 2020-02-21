module MalauzaiFindPlaces

  class APIConnectionError < HTTParty::ResponseError
  end

  class OverQueryLimitError < HTTParty::ResponseError
  end

  class RequestDeniedError < HTTParty::ResponseError
    def to_s
      response.parsed_response['error_message']
    end
  end

  class InvalidRequestError < HTTParty::ResponseError
  end

  class UnknownError < HTTParty::ResponseError
  end

  class NotFoundError < HTTParty::ResponseError
  end

end
