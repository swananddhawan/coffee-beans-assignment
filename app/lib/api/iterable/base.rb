module Api
  module Iterable
    class Base
      include HTTParty

      base_uri ITERABLE_BASE_URI

      raise_on [400, 401, 429, 500, 503]

      # TODO: move key to env/secret
      headers 'Content-Type' => 'application/json', 'X-Api-Key' => ITERABLE_API_KEY

      private

      def post_call!(path, body)
        body_with_camel_case_keys = deep_camelcase_keys(body)
        response = self.class.post(path, body: body_with_camel_case_keys.to_json)
        Response.new(response)
      end

      def deep_camelcase_keys(body)
        body.deep_transform_keys { |key| key.to_s.camelcase(:lower) }
      end
    end
  end
end
