# frozen_string_literal: true

# rubocop:disable Style/BlockDelimiters

require 'webmock'

WebMock.enable!

ITERABLE_BASE_URI = 'https://api.iterable.com'
ITERABLE_API_KEY = 'iterable_api_key'.freeze
ITERABLE_MANDATORY_HEADERS = {
  'X-Api-Key' => ITERABLE_API_KEY
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

################################################################################

###############
# TRACK_EVENT #
###############

track_event = {
  keys: {
    mandatory: %w[eventName userId],
    optional: %w[id createdAt dataFields campaignId templateId createNewFields]
  },
  responses: {
    success: {
      status: 200,
      body: {
        msg: '',
        code: 'Success',
        params: nil
      }.to_json
    },
    invalid_api_key: {
      status: 401,
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
      body: {
        msg: 'Invalid keys',
        code: 'InvalidKey',
        params: {
          ip: '45.141.123.17',
          endpoint: '/api/events/track'
        }
      }.to_json
    }
  }
}.freeze

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

################################################################################

#########
# USERS #
#########

create_or_update_user = {
  keys: {
    mandatory: %w[userId dataFields],
    optional: %w[preferUserId mergeNestedObjects createNewFields]
  },
  responses: {
    success: {
      status: 200,
      body: {
        msg: '',
        code: 'Success',
        params: nil
      }.to_json
    },
    invalid_api_key: {
      status: 401,
      body: {
        msg: 'No, or invalid API key found in request',
        code: 'BadApiKey',
        params: {
          ip: '45.141.123.17',
          endpoint: '/api/users/update'
        }
      }.to_json
    },
    invalid_keys: {
      status: 400,
      body: {
        msg: 'Invalid userId',
        code: 'InvalidUserIdError',
        params: {
          ip: '45.141.123.17',
          endpoint: '/api/users/update'
        }
      }.to_json
    }
  }
}.freeze

# Create user: success
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/users/update").with { |request|
  body = JSON.parse(request.body)
  headers = request.headers

  contain_api_key_in_headers?(headers) &&
    contain_mandatory_keys?(body, create_or_update_user) &&
    contain_valid_keys?(body, create_or_update_user)
}.to_return(create_or_update_user[:responses][:success])

# Create user: invalid keys
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/users/update")
       .with { |request| !contain_valid_keys?(JSON.parse(request.body), create_or_update_user) }
       .to_return(create_or_update_user[:responses][:invalid_keys])

# Create user: empty body
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/users/update").with { |request|
  body = request.body
  body.empty? || JSON.parse(request.body).empty?
}.to_return(create_or_update_user[:responses][:invalid_keys])

# Create user: invalid api key
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/users/update")
       .with { |request| !contain_api_key_in_headers?(request.headers) }
       .to_return(create_or_update_user[:responses][:invalid_api_key])

################################################################################

#########
# EMAIL #
#########

send_email = {
  keys: {
    mandatory: %w[recipientUserId campaignId],
    optional: %w[dataFields sendAt allowRepeatMarketingSends metadata]
  },
  responses: {
    success: {
      status: 200,
      body: {
        msg: '',
        code: 'Success',
        params: nil
      }.to_json
    },
    invalid_api_key: {
      status: 401,
      body: {
        msg: 'No, or invalid API key found in request',
        code: 'BadApiKey',
        params: {
          ip: '45.141.123.17',
          endpoint: '/api/email/target'
        }
      }.to_json
    },
    invalid_keys: {
      status: 400,
      body: {
        msg: 'Invalid userId',
        code: 'InvalidUserIdError',
        params: {
          ip: '45.141.123.17',
          endpoint: '/api/email/target'
        }
      }.to_json
    }
  }
}.freeze

# Create user: success
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/email/target").with { |request|
  body = JSON.parse(request.body)
  headers = request.headers

  contain_api_key_in_headers?(headers) &&
    contain_mandatory_keys?(body, send_email) &&
    contain_valid_keys?(body, send_email)
}.to_return(send_email[:responses][:success])

# Create user: invalid keys
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/email/target")
       .with { |request| !contain_valid_keys?(JSON.parse(request.body), send_email) }
       .to_return(send_email[:responses][:invalid_keys])

# Create user: empty body
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/email/target").with { |request|
  body = request.body
  body.empty? || JSON.parse(request.body).empty?
}.to_return(send_email[:responses][:invalid_keys])

# Create user: invalid api key
WebMock.stub_request(:post, "#{ITERABLE_BASE_URI}/api/email/target")
       .with { |request| !contain_api_key_in_headers?(request.headers) }
       .to_return(send_email[:responses][:invalid_api_key])

################################################################################


# rubocop:enable Style/BlockDelimiters
