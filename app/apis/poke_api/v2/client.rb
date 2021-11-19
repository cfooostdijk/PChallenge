module PokeApi
  module V2
    class Client
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
        response = client.public_send(http_method, endpoint, params)
        Oj.load(response.body)
      end
    end
  end
end
