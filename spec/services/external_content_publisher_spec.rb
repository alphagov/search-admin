RSpec.describe ExternalContentPublisher do
  let(:link) do
    RecommendedLink.new(
      content_id: "some-content-id",
      description: "Public data to help people understand how the government works",
      link: "http://www.data.gov.uk/",
      title: "Data.gov.uk",
    )
  end

  context "publishing" do
    it "saves and publishes a recommended link to the publishing API" do
      expect(Services.publishing_api).to receive(:put_content) do |content_id, payload|
        expect(content_id).to eq("some-content-id")
        expect(payload[:details][:url]).to eq("http://www.data.gov.uk/")
      end
      expect(Services.publishing_api).to receive(:publish).with("some-content-id")

      ExternalContentPublisher.publish(link)
    end

    it "raises an error if saving the link fails" do
      stub_request(:put, "https://publishing-api.test.gov.uk/v2/content/some-content-id").to_return(status: 400)

      expect { ExternalContentPublisher.publish(link) }.to raise_error(GdsApi::HTTPErrorResponse)
    end

    it "raises an error if publishing fails" do
      stub_request(:put, "https://publishing-api.test.gov.uk/v2/content/some-content-id").to_return(status: 200)
      stub_request(:post, "https://publishing-api.test.gov.uk/v2/content/some-content-id/publish").to_return(status: 500)

      expect { ExternalContentPublisher.publish(link) }.to raise_error(GdsApi::HTTPErrorResponse)
    end
  end

  context "unpublishing" do
    it "unpublishes a recommended link in the publishing API" do
      expect(Services.publishing_api).to receive(:unpublish).with("some-content-id", type: "gone")

      ExternalContentPublisher.unpublish(link)
    end

    it "raises an error if unpublishing fails" do
      stub_request(:post, "https://publishing-api.test.gov.uk/v2/content/some-content-id/unpublish").to_return(status: 404)

      expect { ExternalContentPublisher.unpublish(link) }.to raise_error(GdsApi::HTTPErrorResponse)
    end
  end
end
