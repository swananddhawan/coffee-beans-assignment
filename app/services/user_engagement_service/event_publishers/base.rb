class UserEngagementService
  module EventPublishers
    class Base
      def create_published_event!(event_id)
        event_to_publish = PublishedEvent.find_or_initialize_by(event_id: event_id)
        event_to_publish.platform = platform
        event_to_publish.save!

        event_to_publish
      end

      # Override this method to implement publishing of event to a new platform.
      # `event_to_publish` is a record belonging to `PublishedEvent` model.
      def publish_event!(event_to_publish)
        raise NotImplementedError
      end

      # Override this method to implement the condition of whether to send email via this platform.
      # `event_id` is a `id` of `Event` model.
      def send_email_for_event_id?(event_id)
        raise NotImplementedError
      end

      def send_email_for_event_id!(event_id)
        raise NotImplementedError
      end

      private

      # Override this method to return platform name as a String.
      def platform
        raise NotImplementedError
      end
    end
  end
end
