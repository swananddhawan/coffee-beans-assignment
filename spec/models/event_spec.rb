# == Schema Information
#
# Table name: events
#
#  id           :uuid             not null, primary key
#  name         :string           not null
#  other_fields :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid
#
# Indexes
#
#  index_events_on_name     (name)
#  index_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    it 'validates inclusion of name in valid event names' do
      valid_event_names = UserEngagementService.valid_event_names

      valid_event_names.each do |event_name|
        event = build(:event, name: event_name)
        expect(event).to be_valid
      end

      event = build(:event, name: 'invalid_name')
      expect(event).not_to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:published_events).dependent(:destroy) }
  end
end
