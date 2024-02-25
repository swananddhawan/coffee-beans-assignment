class UserEngagementService
  module Errors
    class InvalidEventAttributes < StandardError
      def initialize(attribute_name, attribute_value)
        super("Invalid value, '#{attribute_value}' for '#{attribute_name}'")
      end
    end
  end
end
