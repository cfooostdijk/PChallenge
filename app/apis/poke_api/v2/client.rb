module PokeApi
  module V2
    class Client

      include HttpStatusCodes
      include ApiExceptions

      API_ENDPOINT = 'https://pokeapi.co/api/v2'.freeze
    
      def initialize; end

      def pokemons
        request(
          http_method: :get,
          endpoint: "pokemon"
        )
      end

      def pokemon_base(id)
        request(
          http_method: :get,
          endpoint: "pokemon/#{id}"
        )
      end

      def pokemon_base2(id)
        request(
          http_method: :get,
          endpoint: "characteristic/#{id}"
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
