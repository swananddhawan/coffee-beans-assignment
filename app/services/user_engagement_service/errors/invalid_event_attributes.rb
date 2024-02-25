class UserEngagementService
  module Errors
    class InvalidEventAttributes < StandardError
      def initialize(attribute_name, attribute_value)
        @message = "Invalid value, '#{attribute_value}' for '#{attribute_name}'"
        super
      end
    end
  end
end
