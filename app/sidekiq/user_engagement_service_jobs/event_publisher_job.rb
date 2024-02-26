module UserEngagementServiceJobs
  class EventPublisherJob
    include Sidekiq::Job

    # Refer Assumption#3 in README.md for the reason to chose this approach.
    def perform(event_publisher_class, event_id)
      event_publisher = event_publisher_class.constantize.new

      event_to_publish = event_publisher.create_published_event!(event_id)
      event_publisher.publish_event!(event_to_publish)

      if event_publisher.send_email_for_event_id?(event_id)
        UserEngagementServiceJobs::SendEmailForEventJob.perform_async(event_publisher_class,
                                                                     event_id)
      end
    end
  end
end
