# frozen_string_literal: true

class UserEngagementService
  class << self
    def external_event_publishers
      [
        EventPublishers::Iterable
      ]
    end

    def valid_event_names
      [
        'Clicked event A',
        'Clicked event B'
      ]
    end

    def valid_platforms
      [
        'Iterable'
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
    return if event_name.in?(self.class.valid_event_names) # TODO: add it in model

    raise Errors::Event::InvalidEventAttributes, 'event_name', event_name
  end

  def validate_created_at!(created_at)
    return if created_at <= Time.zone.now

    raise Errors::Event::InvalidEventAttributes, 'created_at', created_at
  end
end