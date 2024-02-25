require 'rails_helper'

RSpec.describe UserEngagementService::EventPublishers::Iterable, :vcr do
  let(:iterable_publisher) { described_class.new }

  describe '#publish_event!' do

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

  describe '#send_email_for_event_id?' do
    context 'when the event is found and is emailable' do
      let(:event) { create(:event, name: UserEngagementService.emailable_events.sample) }

      it 'returns true' do
        expect(iterable_publisher.send_email_for_event_id?(event.id)).to be_truthy
      end
    end

    context 'when the event is not found' do
      it 'returns false' do
        expect(iterable_publisher.send_email_for_event_id?(Faker::Internet.uuid)).to be_falsey
      end
    end

    context 'when the event is found but not emailable' do
      let(:event) { create(:event, name: 'Clicked button A') }

      it 'returns false' do
        expect(iterable_publisher.send_email_for_event_id?(event.id)).to be_falsey
      end
    end
  end

  describe '#send_email_for_event_id!' do
    let(:user) { create(:user) }
    let(:event) { create(:event, user: user) }
    let(:email_api) { instance_double('Api::Iterable::Email') }

    before do
      Timecop.freeze
      allow(Api::Iterable::Email).to receive(:new).and_return(email_api)
      allow(email_api).to receive(:send_email!)
    end

    after do
      Timecop.return
    end

    it 'sends an email for the event' do
      expect(email_api).to receive(:send_email!)
                             .with(event.user_id,
                                   UserEngagementService::EVENT_CAMPAIGN_MAPPING[event.name],
                                   data_fields: {
                                     event: event.other_fields,
                                     user: user.as_json
                                   })

      iterable_publisher.send_email_for_event_id!(event.id)
    end
  end

  describe '#platform' do
    it 'returns "Iterable"' do
      iterable_publisher = described_class.new
      expect(iterable_publisher.platform).to eq('Iterable')
    end
  end
end
