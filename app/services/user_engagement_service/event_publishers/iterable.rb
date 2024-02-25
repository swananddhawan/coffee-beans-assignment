class UserEngagementService
  module EventPublishers
    class Iterable < Base
      def publish_event!(event_to_publish)
        return if event_to_publish.published?

        event = event_to_publish.event

        events_api = Api::Iterable::Events.new
        response = events_api.track_event!(event.name, event.user_id, event.other_fields)

        capture_api_response_details!(event_to_publish, response)
      end

      def send_email_for_event_id?(event_id)
        event = Event.find_by(id: event_id)
        event.present? && UserEngagementService.emailable_events.include?(event.name)
      end

      def send_email_for_event_id!(event_id)
        event = Event.find(event_id)

        email_api = Api::Iterable::Email.new
        email_api.send_email!(
          event.user_id,
          UserEngagementService::EVENT_CAMPAIGN_MAPPING[event.name],
          data_fields: {
            event: event.other_fields,
            user: event.user.as_json
          }
        )
      end

      def platform
        'Iterable'
      end

      private

      def capture_api_response_details!(event_published, response)
        api_responses = event_published.api_responses || []
        api_responses << response.parsed_response

        if response.success?
          event_published.update!(published_at: Time.zone.now,
                                  api_responses: api_responses)
        else
          event_published.update!(api_responses: api_responses)

          raise HTTParty::ResponseError, response.httparty_response
        end
      end
    end
  end
end
