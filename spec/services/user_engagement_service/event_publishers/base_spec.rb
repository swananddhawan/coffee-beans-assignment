require 'rails_helper'

RSpec.describe UserEngagementService::EventPublishers::Base do
  describe '#create_published_event!' do
    let(:publisher) { described_class.new }
    let(:event_id) { Faker::Internet.uuid }
    let(:published_event_success) do
      instance_double(
        'PublishedEvent',
        :platform= => nil,
        :save! => true
      )
    end

    before do
      allow(publisher).to receive(:platform)
                            .and_return(UserEngagementService.valid_platforms.sample)
    end


    it 'creates a new published event with the given event_id' do
      expect(PublishedEvent).to receive(:find_or_initialize_by)
                                  .with(event_id: event_id)
                                  .and_return(published_event_success)

      publisher.create_published_event!(event_id)
    end

    it 'saves the platform name to the created published event' do
      expect(PublishedEvent).to receive(:find_or_initialize_by)
                                  .with(event_id: event_id)
                                  .and_return(published_event_success)
      publisher.create_published_event!(event_id)
    end

    it 'raises an error if saving the published event fails' do
      allow(published_event_success).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)
      expect {
        publisher.create_published_event!(event_id)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#publish_event!' do
    it 'raises NotImplementedError' do
      publisher = described_class.new
      event_to_publish = double('PublishedEvent')
      expect {
        publisher.publish_event!(event_to_publish)
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#send_email_for_event_id?' do
    it 'raises NotImplementedError' do
      publisher = described_class.new
      expect {
        publisher.send_email_for_event_id?(Faker::Internet.uuid)
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#send_email_for_event_id!' do
    it 'raises NotImplementedError' do
      publisher = described_class.new
      expect {
        publisher.send_email_for_event_id!(Faker::Internet.uuid)
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#platform' do
    it 'raises NotImplementedError' do
      publisher = described_class.new
      expect {
        publisher.send(:platform)
      }.to raise_error(NotImplementedError)
    end
  end
end
