# frozen_string_literal: true
# rubocop:disable Style/BlockDelimiters

require 'webmock'

WebMock.enable!

ITERABLE_BASE_URI = 'https://api.iterable.com'
ITERABLE_API_KEY = 'iterable_api_key'
ITERABLE_MANDATORY_HEADERS = {
  'X-Api-Key' => ITERABLE_API_KEY
}.freeze

track_event = {
  keys: {
    mandatory: ['eventName'],
    optional: %w[email userId id createdAt dataFields campaignId templateId createNewFields]
  },
  responses: {
    success: {
      status: 200,
      headers: { content_type: 'application/json' },
      body: {
        msg: '',
        code: 'Success',
        params: nil
      }.to_json
    },
    invalid_api_key: {
      status: 401,
      headers: { content_type: 'application/json' },
      body: {
        msg: 'No, or invalid API key found in request',
        code: 'BadApiKey',
        params: {
          ip: '45.141.123.17',
          endpoint: '/api/events/track'
        }
      }.to_json
    },
    invalid_keys: {
      status: 400,
      headers: { content_type: 'application/json' },
      body: {
        msg: 'Invalid keys',
        code: 'BadApiKey',
        params: {
          ip: '45.141.123.17',
          endpoint: '/api/events/track'
        }
      }.to_json
    }
  }
}.freeze

def contain_mandatory_keys?(body, optional_and_mandatory_keys)
  mandatory_keys = optional_and_mandatory_keys[:keys][:mandatory]
  mandatory_keys.all? { |mandatory_key| body.key?(mandatory_key) }
end

def contain_valid_keys?(body, optional_and_mandatory_keys)
  optional_keys = optional_and_mandatory_keys[:keys][:optional]
  mandatory_keys = optional_and_mandatory_keys[:keys][:mandatory]

  all_keys = optional_keys + mandatory_keys
  (body.keys - all_keys).blank?
end

def contain_api_key_in_headers?(headers)
  ITERABLE_MANDATORY_HEADERS.all? { |k, v| headers.key?(k) && headers[k] == v }
end

###############
# TRACK_EVENT #
###############

# Track event: success
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/events/track").with { |request|
  body = JSON.parse(request.body)
  headers = request.headers

  contain_api_key_in_headers?(headers) &&
    contain_mandatory_keys?(body, track_event) &&
    contain_valid_keys?(body, track_event)
}.to_return(track_event[:responses][:success])

# Track event: invalid keys
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/events/track")
       .with { |request| !contain_valid_keys?(JSON.parse(request.body), track_event) }
       .to_return(track_event[:responses][:invalid_keys])

# Track event: empty body
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/events/track").with { |request|
  body = request.body
  body.empty? || JSON.parse(request.body).empty?
}.to_return(track_event[:responses][:invalid_keys])

# Track event: invalid api key
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/events/track")
       .with { |request| !contain_api_key_in_headers?(request.headers) }
       .to_return(track_event[:responses][:invalid_api_key])

# rubocop:enable Style/BlockDelimiters