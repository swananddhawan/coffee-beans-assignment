# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApplicationController
      def create
        current_time = Time.zone.now

        user_engagement_service = UserEngagementService.new(current_user_id)
        user_engagement_service.track_event!(event_params[:name],
                                             current_time,
                                             event_params[:data_fields].to_h)

        render status: :ok, json: { data: {}, errors: nil, message: 'Event received.' }
      end

      private

      def event_params
        params.require(:event).permit!
      end
    end
  end
end
