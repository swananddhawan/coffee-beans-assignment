# frozen_string_literal: true

module UserEngagementServiceJobs
  class CaptureEventJob
    include Sidekiq::Job

    def perform(user_id, event_name, created_at_string, data_fields)
      event = Event.create!(user_id: user_id,
                            name: event_name,
                            created_at: Time.zone.parse(created_at_string),
                            other_fields: data_fields)

      event.class.publishers.each do |publisher|
        UserEngagementServiceJobs::EventPublisherJob.perform_async(publisher.name, event.id)
      end
    end
  end
end
