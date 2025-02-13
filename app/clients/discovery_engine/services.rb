module DiscoveryEngine
  # Mixin providing access to the Discovery Engine API client's services
  module Services
    # Returns a Discovery Engine client for the control service
    def control_service
      @control_service ||= Google::Cloud::DiscoveryEngine.control_service(version: :v1)
    end
  end
end
