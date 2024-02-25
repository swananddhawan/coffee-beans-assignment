class UserEngagementService
  module EventPublishers
    class Iterable < Base
      def publish_event!(event_to_publish)
        # TODO: publish only if event is of `type B`
        return if event_to_publish.published?

        event = event_to_publish.event

        events_api = Api::Iterable::Events.new
        response = events_api.track_event!(event.name, event.user_id, event.other_fields)

        capture_api_response_details!(event_to_publish, response)
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
