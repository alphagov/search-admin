module PublishingApi
  # Client to synchronize records (such as content item on Publishing APIs) that can be published using Publishing
  # API.
  #
  # Expects records to respond to `#content_id` and `#to_publishing_api_content_item`.
  class ContentItemClient
    # The type of unpublishing to perform on the content item when deleting it.
    UNPUBLISH_TYPE = "gone".freeze

    # Creates a corresponding content item for this record on Publishing API.
    #
    # Note Publishing API does not differentiate between create and update operations.
    def create(record)
      publishing_api_service.put_content(
        record.content_id,
        record.to_publishing_api_content_item,
      )
      publishing_api_service.publish(record.content_id)
    rescue GdsApi::BaseError => e
      record.errors.add(:base, :remote_error)
      raise ClientError, "Could not publish content item on Publishing API: #{e.message}"
    end
    alias_method :update, :create

    # Deletes the corresponding content item for this record on Publishing API.
    def delete(record)
      publishing_api_service.unpublish(record.content_id, type: UNPUBLISH_TYPE)
    rescue GdsApi::BaseError => e
      record.errors.add(:base, :remote_error)
      raise ClientError, "Could not unpublish content item on Publishing API: #{e.message}"
    end

  private

    def publishing_api_service
      @publishing_api_service ||= GdsApi::PublishingApi.new(
        Plek.find("publishing-api"),
        bearer_token: Rails.configuration.publishing_api_bearer_token,
      )
    end
  end
end
