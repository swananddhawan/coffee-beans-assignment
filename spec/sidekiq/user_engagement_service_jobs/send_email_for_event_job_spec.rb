require 'rails_helper'

RSpec.describe UserEngagementServiceJobs::SendEmailForEventJob, type: :job do
  describe '#perform' do
    let(:publisher_class) { 'UserEngagementService::EventPublishers::Iterable' }
    let(:event_id) { Faker::Internet.uuid }
    let(:event_publisher) { instance_double('UserEngagementService::EventPublishers::Iterable') }

    before do
      allow(UserEngagementService::EventPublishers::Iterable).to receive(:new).and_return(event_publisher)
      allow(event_publisher).to receive(:send_email_for_event_id!).with(event_id)
    end

    it 'sends email for the event' do
      expect(event_publisher).to receive(:send_email_for_event_id!).with(event_id)

      described_class.new.perform(publisher_class, event_id)
    end
  end
end
