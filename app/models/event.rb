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
class Event < ApplicationRecord
  validates :name, presence: true, inclusion: { in: UserEngagementService.valid_event_names }

  belongs_to :user

  has_many :published_events, dependent: :destroy
end
