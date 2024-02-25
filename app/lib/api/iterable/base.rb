module Api
  module Iterable
    class Base
      include HTTParty

      base_uri ITERABLE_BASE_URI

      raise_on [400, 401, 429, 500, 503]

      private

      def post_call!(path, body)
        body_with_camel_case_keys = deep_camelcase_keys(body)
        response = self.class.post(path, headers: headers, body: body_with_camel_case_keys.to_json)
        Response.new(response)
      end

      def deep_camelcase_keys(body)
        body.deep_transform_keys { |key| key.to_s.camelcase(:lower) }
      end

      def headers
        {
          'Content-Type' => 'application/json',
          'X-Api-Key' => ITERABLE_API_KEY
        }
      end
    end
  end
end
