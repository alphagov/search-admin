module DiscoveryEngine
  # Mixin providing access to the Discovery Engine API client's services
  module Services
  module_function

    # Returns a Discovery Engine client for the completion service
    def completion_service
      @completion_service ||= Google::Cloud::DiscoveryEngine.completion_service(version: :v1)
    end

    def document_service
      @document_service ||= Google::Cloud::DiscoveryEngine.document_service(version: :v1)
    end
  end
end
