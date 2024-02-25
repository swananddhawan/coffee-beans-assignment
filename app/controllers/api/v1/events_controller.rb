# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApplicationController
      def create
        current_time = Time.zone.now

        user_engagement_service = UserEngagementService.new(current_user_id)
        user_engagement_service.track_event!(event_params[:name],
                                             current_time,
                                             event_params[:data_fields])

        render status: :ok, json: { data: {}, errors: nil, message: 'Event received.' }
      end

      private

      def event_params
        params.permit!(:event)
      end
    end
  end
end
