# frozen_string_literal: true

class UserEngagementService
  EVENTS = {
    clicked_button_a: 'Clicked button A',
    clicked_button_b: 'Clicked button B'
  }.freeze

  EVENT_CAMPAIGN_MAPPING = {
    'Clicked button A' => 0,
    'Clicked button B' => 1
  }.freeze

  class << self
    # TODO: see if you can use symbols for event names
    def external_event_publishers
      [
        EventPublishers::Iterable
      ]
    end

    def valid_event_names
      [
        EVENTS[:clicked_button_a],
        EVENTS[:clicked_button_b]
      ]
    end

    def valid_platforms
      [
        'Iterable'
      ]
    end

    def emailable_events
      [
        EVENTS[:clicked_button_b]
      ]
    end
  end

  attr_reader :user_id

  def initialize(user_id)
    @user_id = user_id
  end

  def track_event!(event_name, created_at, data_fields)
    validate_event_name!(event_name)
    validate_created_at!(created_at)

    UserEngagementServiceJobs::CaptureEventJob.perform_async(
      user_id,
      event_name,
      created_at.to_s,
      data_fields
    )
  end

  def validate_event_name!(event_name)
    return if event_name.in?(self.class.valid_event_names)

    raise Errors::InvalidEventAttributes.new('event_name', event_name)
  end

  def validate_created_at!(created_at)
    return if created_at.past?

    raise Errors::InvalidEventAttributes.new('created_at', created_at)
  end
end
