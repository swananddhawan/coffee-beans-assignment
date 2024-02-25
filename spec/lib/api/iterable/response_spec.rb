# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Iterable::Response do
  describe '#initialize' do
    let(:httparty_response) { instance_double(HTTParty::Response) }
    let(:response_body) do
      {
        code: 200,
        msg: 'Success',
        params: { key: 'value' }
      }.to_json
    end

    before do
      allow(httparty_response).to receive(:headers).and_return({})
      allow(httparty_response).to receive(:code).and_return(200)
      allow(httparty_response).to receive(:body).and_return(response_body)
    end

    it 'initializes with HTTParty response' do
      iterable_response = described_class.new(httparty_response)

      expect(iterable_response.httparty_response).to eq(httparty_response)
      expect(iterable_response.parsed_response).to eq(JSON.parse(response_body, symbolize_names: true))
      expect(iterable_response.headers).to eq({})
      expect(iterable_response.http_code).to eq(200)
      expect(iterable_response.iterable_code).to eq(200)
      expect(iterable_response.iterable_message).to eq('Success')
      expect(iterable_response.iterable_params).to eq({ key: 'value' })
    end
  end
end
