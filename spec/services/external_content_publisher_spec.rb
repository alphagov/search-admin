require 'spec_helper'

RSpec.describe ExternalContentPublisher do
  it "saves and publishes a recommended link to the publishing API" do
    link = RecommendedLink.new(
      content_id: "some-content-id",
      description: "Public data to help people understand how the government works",
      link: "http://www.data.gov.uk/",
      title: "Data.gov.uk",
    )

    expect(Services.publishing_api).to receive(:put_content) do |content_id, payload|
      expect(content_id).to eq("some-content-id")
      expect(payload[:details][:url]).to eq("http://www.data.gov.uk/")
    end
    expect(Services.publishing_api).to receive(:publish).with("some-content-id")

    ExternalContentPublisher.publish(link)
  end

  it "unpublishes a recommended link in the publishing API" do
    link = RecommendedLink.new(content_id: "some-content-id")

    expect(Services.publishing_api).to receive(:unpublish).with("some-content-id", type: "gone")

    ExternalContentPublisher.unpublish(link)
  end
end
