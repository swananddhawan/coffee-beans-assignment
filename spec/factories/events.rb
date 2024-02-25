FactoryBot.define do
  factory :event do
    name { UserEngagementService.valid_event_names.sample }
    other_fields { {} }

    association :user, factory: :user
  end
end
