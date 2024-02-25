# == Schema Information
#
# Table name: published_events
#
#  id            :uuid             not null, primary key
#  api_responses :jsonb
#  platform      :string           not null
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  event_id      :uuid
#
# Indexes
#
#  index_published_events_on_event_id               (event_id)
#  index_published_events_on_event_id_and_platform  (event_id,platform) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe PublishedEvent, type: :model do
  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:platform).in_array(UserEngagementService.valid_platforms) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:event) }
  end

  describe '#published?' do
    it 'returns true if published_at is present' do
      published_event = build(:published_event, published_at: Time.current)
      expect(published_event.published?).to eq(true)
    end

    it 'returns false if published_at is nil' do
      published_event = build(:published_event, published_at: nil)
      expect(published_event.published?).to eq(false)
    end
  end
end
