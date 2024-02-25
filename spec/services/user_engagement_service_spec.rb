require 'rails_helper'

RSpec.describe UserEngagementService do
  describe '.external_event_publishers' do
    it 'returns an array of external event publishers' do
      expect(UserEngagementService.external_event_publishers).to eq([UserEngagementService::EventPublishers::Iterable])
    end
  end

  describe '.valid_event_names' do
    it 'returns an array of valid event names' do
      expect(UserEngagementService.valid_event_names).to eq(['Clicked button A', 'Clicked button B'])
    end
  end

  describe '.valid_platforms' do
    it 'returns an array of valid platforms' do
      expect(UserEngagementService.valid_platforms).to eq(['Iterable'])
    end
  end

  describe '#initialize' do
    let(:user_id) { Faker::Internet.uuid }

    it 'sets the user_id attribute' do
      user_engagement_service = UserEngagementService.new(user_id)
      expect(user_engagement_service.user_id).to eq(user_id)
    end
  end

  describe '#track_event!' do
    let(:user_id) { Faker::Internet.uuid }
    let(:user_engagement_service) { UserEngagementService.new(user_id) }

    it 'calls UserEngagementServiceJobs::CaptureEventJob.perform_async with correct arguments' do
      event_name = 'Clicked button A'
      created_at = Time.zone.now
      data_fields = { key: 'value' }

      expect(UserEngagementServiceJobs::CaptureEventJob).
        to receive(:perform_async).with(user_id, event_name, created_at.to_s, data_fields)

      user_engagement_service.track_event!(event_name, created_at, data_fields)
    end

    it 'raises an error if event name is invalid' do
      expect {
        user_engagement_service.track_event!('Invalid event', Time.zone.now, {})
      }.to raise_error(UserEngagementService::Errors::InvalidEventAttributes, /event_name/)
    end

    it 'raises an error if created_at is not in the past' do
      future_time = Time.zone.now + 1.hour

      expect {
        user_engagement_service.track_event!('Clicked button A', future_time, {})
      }.to raise_error(UserEngagementService::Errors::InvalidEventAttributes, /created_at/)
    end
  end

  describe '#validate_event_name!' do
    let(:user_id) { Faker::Internet.uuid }
    let(:user_engagement_service) { UserEngagementService.new(user_id) }

    it 'does not raise error if event name is valid' do
      expect {
        user_engagement_service.send(:validate_event_name!, 'Clicked button A')
      }.not_to raise_error
    end

    it 'raises an error if event name is invalid' do
      expect {
        user_engagement_service.send(:validate_event_name!, 'Invalid event')
      }.to raise_error(UserEngagementService::Errors::InvalidEventAttributes, /event_name/)
    end
  end

  describe '#validate_created_at!' do
    let(:user_id) { Faker::Internet.uuid }
    let(:user_engagement_service) { UserEngagementService.new(user_id) }

    it 'does not raise error if created_at is in the past' do
      expect {
        user_engagement_service.send(:validate_created_at!, Time.zone.now - 1.hour)
      }.not_to raise_error
    end

    it 'raises an error if created_at is not in the past' do
      future_time = Time.zone.now + 1.hour
      expect {
        user_engagement_service.send(:validate_created_at!, future_time)
      }.to raise_error(UserEngagementService::Errors::InvalidEventAttributes, /created_at/)
    end
  end
end
