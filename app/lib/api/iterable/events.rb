module Api
  module Iterable
    class Events < Base
      def track_event(name, user_id, attributes = {})
        attributes[:event_name] = name
        attributes[:user_id] = user_id

        post_call!('/api/events/track', attributes)
      end
    end
  end
end
