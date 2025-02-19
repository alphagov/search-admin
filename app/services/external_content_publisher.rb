class ExternalContentPublisher
  def self.publish(recommended_link)
    Services.publishing_api.put_content(
      recommended_link.content_id,
      recommended_link.to_publishing_api_content_item,
    )
    Services.publishing_api.publish(recommended_link.content_id)
  end

  def self.unpublish(recommended_link)
    Services.publishing_api.unpublish(recommended_link.content_id, type: "gone")
  end
end
