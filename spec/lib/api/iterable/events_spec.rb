require 'rails_helper'

RSpec.describe Api::Iterable::Events do
  describe '#track_event' do
    let(:attributes) { { key: 'value' } }
    let(:event_name) { 'event_name' }
    let(:user_id) { '1234-user' }
    let(:merged_attributes) do
      attributes.merge(event_name: event_name, user_id: user_id)
    end

    it 'calls post_call! with correct parameters' do
      expect(subject).to receive(:post_call!).with('/api/events/track', merged_attributes)
      subject.track_event(event_name, user_id, attributes)
    end
  end
end
