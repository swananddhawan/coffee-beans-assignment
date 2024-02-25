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

    context 'when email needs to be sent for the event' do
      before do
        allow(event_publisher).to receive(:send_email_for_event_id?).with(event.id).and_return(true)
        allow(event_publisher).to receive(:send_email_for_event_id!).with(event.id)
      end

      it 'creates and publishes the event and sends an email' do
        expect(event_publisher).to receive(:create_published_event!).with(event.id).and_return(event_to_publish)
        expect(event_publisher).to receive(:publish_event!).with(event_to_publish)
        expect(UserEngagementServiceJobs::SendEmailForEventJob).
          to receive(:perform_async).with(event_publisher_class, event.id)

        described_class.new.perform(event_publisher_class, event.id)
      end
    end

    context 'when email does not need to be sent for the event' do
      before do
        allow(event_publisher).to receive(:send_email_for_event_id?).with(event.id).and_return(false)
      end

      it 'creates and publishes the event' do
        expect(event_publisher).to receive(:create_published_event!).with(event.id).and_return(event_to_publish)
        expect(event_publisher).to receive(:publish_event!).with(event_to_publish)
        expect(UserEngagementServiceJobs::SendEmailForEventJob).to_not receive(:perform_async)
        described_class.new.perform(event_publisher_class, event.id)
      end
    end
  end
end
