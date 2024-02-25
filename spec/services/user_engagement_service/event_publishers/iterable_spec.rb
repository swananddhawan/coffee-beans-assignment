require 'rails_helper'

RSpec.describe UserEngagementService::EventPublishers::Iterable, :vcr do
  describe '#publish_event!' do
    let(:iterable_publisher) { described_class.new }

    let(:event) { create(:event) }
    let(:event_to_publish) { create(:published_event, event: event) }

    let(:events_api) { instance_double('Api::Iterable::Events') }
    let(:success_response) do
      instance_double(
        'Api::Iterable::Response',
        success?: true,
        parsed_response: {},
        httparty_response: {}
      )
    end

    let(:failure_response) do
      instance_double(
        'Api::Iterable::Response',
        success?: false,
        parsed_response: {},
        httparty_response: {}
      )
    end

    before do
      allow(Api::Iterable::Events).to receive(:new).and_return(events_api)
      allow(events_api).to receive(:track_event!).and_return(success_response)
    end

    it 'tracks event using Iterable API' do
      expect(events_api).to receive(:track_event!).with(event.name, event.user_id, event.other_fields)
      iterable_publisher.publish_event!(event_to_publish)
    end

    context 'when API response is successful' do
      it 'updates published_at and api_responses of the published event' do
        expect(event_to_publish).to receive(:update!).with(published_at: anything, api_responses: [{}])
        iterable_publisher.publish_event!(event_to_publish)
      end
    end

    context 'when API response is not successful' do
      before do
        allow(events_api).to receive(:track_event!).and_return(failure_response)
      end

      it 'updates api_responses of the published event and raises HTTParty::ResponseError' do
        expect(event_to_publish).to receive(:update!).with(api_responses: [{}])
        expect {
          iterable_publisher.publish_event!(event_to_publish)
        }.to raise_error(HTTParty::ResponseError)
      end
    end

    context 'when event is already published' do
      let(:event_to_publish) { instance_double('PublishedEvent', published?: true) }

      it 'does not track the event' do
        expect(events_api).not_to receive(:track_event!)
        iterable_publisher.publish_event!(event_to_publish)
      end
    end
  end

  describe '#publisher_name' do
    it 'returns "Iterable"' do
      iterable_publisher = described_class.new
      expect(iterable_publisher.publisher_name).to eq('Iterable')
    end
  end
end
