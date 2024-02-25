require 'rails_helper'

RSpec.describe UserEngagementServiceJobs::EventPublisherJob, type: :job do
  describe '#perform' do
    let(:event_publisher_class) { UserEngagementService::EventPublishers::Iterable.name }
    let(:event) { create(:event) }
    let(:event_publisher) { instance_double('EventPublishers::Iterable') }
    let(:event_to_publish) { instance_double('PublishedEvent') }

    before do
      allow(event_publisher_class.constantize).to receive(:new).and_return(event_publisher)
      allow(event_publisher).to receive(:create_published_event!).and_return(event_to_publish)
      allow(event_publisher).to receive(:publish_event!)
    end

    it 'creates a new published event and publishes it' do
      expect(event_publisher_class.constantize).to receive(:new)
      expect(event_publisher).to receive(:create_published_event!).with(event.id).and_return(event_to_publish)
      expect(event_publisher).to receive(:publish_event!).with(event_to_publish)

      described_class.new.perform(event_publisher_class, event.id)
    end
  end
end
