module UserEngagementServiceJobs
  class EventPublisherJob
    include Sidekiq::Job

    def perform(event_publisher_class, event_id)
      event_publisher = event_publisher_class.constantize.new

      event_to_publish = event_publisher.create_published_event!(event_id)
      event_publisher.publish_event!(event_to_publish)

      # TODO: move this to another job
      if event_publisher.send_email_for_event_id?(event_id)
        event_publisher.send_email_for_event_id!(event_id)
      end
    end
  end
end
