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
  pending "add some examples to (or delete) #{__FILE__}"
end
