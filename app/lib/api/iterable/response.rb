module Api
  module Iterable
    class Response
      attr_reader :httparty_response,
                  :parsed_response,
                  :headers,
                  :http_code,
                  :iterable_code,
                  :iterable_message,
                  :iterable_params

      def initialize(httparty_response)
        @httparty_response = httparty_response
        @parsed_response = JSON.parse(httparty_response.body, symbolize_names: true)
        @headers = httparty_response.headers
        @http_code = httparty_response.code
        @iterable_code = parsed_response[:code]
        @iterable_message = parsed_response[:msg]
        @iterable_params = parsed_response[:params].to_h # For nil responses
      end
    end
  end
end
