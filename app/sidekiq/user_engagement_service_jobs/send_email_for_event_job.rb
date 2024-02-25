module UserEngagementServiceJobs
  class SendEmailForEventJob
    include Sidekiq::Job

    def perform(event_publisher_class, event_id)
      event_publisher = event_publisher_class.constantize.new
      event_publisher.send_email_for_event_id!(event_id)
    end
  end
end
