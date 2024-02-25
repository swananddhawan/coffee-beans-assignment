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
class PublishedEvent < ApplicationRecord
  validates :platform, inclusion: { in: UserEngagementService.valid_platforms }

  belongs_to :event

  def published?
    published_at.present?
  end
end
