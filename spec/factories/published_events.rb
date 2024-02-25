FactoryBot.define do
  factory :published_event do
    association :event, factory: :event
    platform { UserEngagementService.valid_platforms.sample }
    api_responses { [] }
  end
end
