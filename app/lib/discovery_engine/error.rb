module DiscoveryEngine
  # An application-level representation of a Google::Cloud::Error raised by the Discovery Engine API
  # client.
  class Error < StandardError
    # Returns whether the error is likely to be caused by an invalid request/user input, for example
    # an invalid value provided for a field.
    def invalid_request?
      # Unfortunately the Discovery Engine API does not return any helpful error details as of
      # January 2025, so we just assume that an `InvalidArgumentError` is probably related to
      # invalid user input.
      cause.is_a?(Google::Cloud::InvalidArgumentError)
    end

    # Try to extract the `details` field from the original Discovery Engine error, which may contain
    # a more helpful description of what happened than our own error messages.
    def message
      cause&.details || super
    end
  end
end
