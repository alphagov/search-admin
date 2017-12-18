class ExternalContentPublisher
  def self.publish(recommended_link)
    payload = ExternalContentPresenter.new(recommended_link)
      .present_for_publishing_api

    Services.publishing_api.put_content(recommended_link.content_id, payload)
    Services.publishing_api.publish(recommended_link.content_id)
  end

  def self.unpublish(recommended_link)
    Services.publishing_api.unpublish(recommended_link.content_id, type: "gone")
  end
end
