require 'rails_helper'

RSpec.describe Api::Iterable::Base, :vcr do
  it 'includes HTTParty module' do
    expect(described_class).to include(HTTParty)
  end

  it 'raises error on 400, 401, 429, 500 and 503 HTTP status codes' do
    raise_on = subject.class.default_options[:raise_on]
    expect(raise_on).to eq([400, 401, 429, 500, 503])
  end

  it 'has defined base_uri' do
    expect(subject.class.base_uri).to eq('https://api.iterable.com')
  end

  describe '#post_call!' do
    let(:path) { '/api/events/track' }
    let(:body) { { event_name: 'test_value', user_id: '1234' } }
    let(:response_body) { { success: true }.to_json }
    let(:body_with_camelcase_keys) do
      body.deep_transform_keys { |key| key.to_s.camelcase(:lower) }
    end

    let(:expected_headers) do
      {
        'Content-Type' => 'application/json',
        'X-Api-Key' => 'iterable_api_key'
      }
    end

    it 'calls HTTParty.post with camelcased keys in the body and includes required headers' do
      mocked_subject_class = class_double(HTTParty, post: {})
      allow(subject).to receive(:class).and_return(mocked_subject_class)
      allow(Api::Iterable::Response).to receive(:new).and_return(nil)

      expect(mocked_subject_class).to receive(:post).with(path,
                                                          headers: expected_headers,
                                                          body: body_with_camelcase_keys.to_json)
      subject.send(:post_call!, path, body)
    end

    it 'returns a Response object' do
      expect(subject.send(:post_call!, path, body)).to be_a(Api::Iterable::Response)
    end
  end
end
