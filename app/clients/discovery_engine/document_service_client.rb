module DiscoveryEngine
  class DocumentServiceClient
    def delete_document(content_id:)
      document_service.delete_document(name: document_name(content_id))
      Rails.logger.info("Successfully deleted document with content id #{content_id}.")
    rescue Google::Cloud::NotFoundError
      Rails.logger.info("Did not delete document with content id #{content_id} as it doesn't exist remotely.")
    end

    def get_document(content_id:)
      document_service.get_document(name: document_name(content_id))
    rescue Google::Cloud::NotFoundError => e
      Rails.logger.error("Unable to retrieve document with content id #{content_id} as it doesn't exist remotely.")
      raise e
    end

  private

    def document_name(content_id)
      [Branch.default.name, "documents", content_id].join("/")
    end

    def document_service
      @document_service ||= DiscoveryEngine::Services.document_service
    end
  end
end
