RSpec.describe "publish_external_links tasks" do
  describe "publish_external_links:publishing_api" do
    let(:content_item_client) { instance_double(PublishingApi::ContentItemClient) }
    let(:basic_recommended_link) { build_stubbed(:recommended_link) }
    let(:additional_recommended_link) do
      build_stubbed(
        :recommended_link,
        content_id: "some-content-id",
        title: "Data.gov.uk",
        link: "http://www.data.gov.uk/",
        description: "Public data to help people understand how the government works",
        keywords: "data, open data, api",
      )
    end

    before do
      allow(PublishingApi::ContentItemClient).to receive(:new).and_return(content_item_client)
      allow(RecommendedLink).to receive(:all).and_return(double.as_null_object)
      allow(RecommendedLink.all)
        .to receive(:find_each)
        .and_yield(basic_recommended_link)
        .and_yield(additional_recommended_link)
      Rake::Task["publish_external_links:publishing_api"].reenable
    end

    it "calls the ContentItemClient" do
      expect(content_item_client)
        .to receive(:create)
        .with(basic_recommended_link).ordered

      expect(content_item_client)
        .to receive(:create)
        .with(additional_recommended_link).ordered

      Rake::Task["publish_external_links:publishing_api"].invoke
    end
  end
end
