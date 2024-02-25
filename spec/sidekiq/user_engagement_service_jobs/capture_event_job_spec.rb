require 'rails_helper'

RSpec.describe UserEngagementServiceJobs::CaptureEventJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:event_name) { UserEngagementService.valid_event_names.sample }
    let(:created_at_string) { '2023-01-01T12:00:00Z' }
    let(:data_fields) { { field1: 'value1', field2: 'value2' } }

    let(:new_mocked_event) { build(:event, id: Faker::Internet.uuid) }

    it 'creates a new event with the given attributes and enqueues event publisher jobs' do
      initial_count = Event.count

      described_class.new.perform(user.id, event_name, created_at_string, data_fields)

      expect(Event.count).to eq(initial_count + 1)

      new_event = Event.last
      expect(new_event.user_id).to eq(user.id)
      expect(new_event.name).to eq(event_name)
      expect(new_event.created_at).to eq(Time.zone.parse(created_at_string))
      expect(new_event.other_fields).to eq(data_fields.stringify_keys)

    end

    it 'en-queues event publisher jobs' do
      allow(Event).to receive(:create!).and_return(new_mocked_event)

      UserEngagementService.external_event_publishers.each do |publisher|
        expect(UserEngagementServiceJobs::EventPublisherJob)
          .to receive(:perform_async).with(publisher.name, new_mocked_event.id)
      end

      described_class.new.perform(user.id, event_name, created_at_string, data_fields)
    end
  end
end
