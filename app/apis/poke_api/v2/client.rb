module PokeApi
  module V2
    class Client

      PokeApiError = Class.new(StandardError)
      BadRequestError = Class.new(PokeApiError)
      UnauthorizedError = Class.new(PokeApiError)
      ForbiddenError = Class.new(PokeApiError)
      ApiRequestsQuotaReachedError = Class.new(PokeApiError)
      NotFoundError = Class.new(PokeApiError)
      UnprocessableEntityError = Class.new(PokeApiError)
      ApiError = Class.new(PokeApiError)
      
      HTTP_OK_CODE = 200

      HTTP_BAD_REQUEST_CODE = 400
      HTTP_UNAUTHORIZED_CODE = 401
      HTTP_FORBIDDEN_CODE = 403
      HTTP_NOT_FOUND_CODE = 404
      HTTP_UNPROCESSABLE_ENTITY_CODE = 422
      HTTP_TOO_MANY_REQUEST = 429

      API_ENDPOINT = 'https://pokeapi.co/api/v2'.freeze

      def initialize; end

      def pokemons
        request(
          http_method: :get,
          endpoint: "pokemon"
        )
      end

      private

      def client
        @_client ||= Faraday.new(API_ENDPOINT) do |client|
          client.request :url_encoded
          client.adapter Faraday.default_adapter
        end
      end

      def request(http_method:, endpoint:, params: {})
        @response = client.public_send(http_method, endpoint, params)
        parsed_response = Oj.load(@response.body)

        return parsed_response if response_successful?

        raise error_class, "Code: #{@response.status}, response: #{@response.body}"
      end

      def response_successful?
        @response.status == HTTP_OK_CODE
      end

      def error_class
        case @response.status
        when HTTP_BAD_REQUEST_CODE
          BadRequestError
        when HTTP_UNAUTHORIZED_CODE
          UnauthorizedError
        when HTTP_FORBIDDEN_CODE
          return ApiRequestsQuotaReachedError if api_requests_quota_reached?
          ForbiddenError
        when HTTP_NOT_FOUND_CODE
          NotFoundError
        when HTTP_UNPROCESSABLE_ENTITY_CODE
          UnprocessableEntityError
        else
          ApiError
        end
      end

      def api_requests_quota_reached?
        @response.body.match?(API_REQUESTS_QUOTA_REACHED_MESSAGE)
      end
    end
  end
end
