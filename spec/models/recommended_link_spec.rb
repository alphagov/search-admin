require "govuk_schemas/validator"

RSpec.describe RecommendedLink do
  subject(:recommended_link) { build(:recommended_link) }

  describe "#content_id" do
    it "is generated on initial create" do
      expect { recommended_link.save }.to change { recommended_link.content_id }.from(nil)
    end
  end

  describe "#preview_url" do
    let(:finder_frontend_search) do
      instance_double(FinderFrontendSearch, url: "https://example.org")
    end

    before do
      allow(FinderFrontendSearch).to receive(:for_keywords)
        .with(recommended_link.title)
        .and_return(finder_frontend_search)
    end

    it "returns the preview URL" do
      expect(recommended_link.preview_url).to eq("https://example.org")
    end
  end

  describe "#to_publishing_api_content_item" do
    subject(:content_item) do
      recommended_link.to_publishing_api_content_item
    end

    let(:recommended_link) do
      build(
        :recommended_link,
        content_id: "some-content-id",
        title: "Data.gov.uk",
        link: "http://www.data.gov.uk/",
        description: "Public data to help people understand how the government works",
        keywords: "data, open data, api",
      )
    end
    let(:validator) do
      GovukSchemas::Validator.new("external_content", "publisher", content_item)
    end

    it "returns the content item for the publishing API" do
      expect(recommended_link.to_publishing_api_content_item).to eq({
        title: "Data.gov.uk",
        description: "Public data to help people understand how the government works",
        details: {
          hidden_search_terms: ["data, open data, api"],
          url: "http://www.data.gov.uk/",
        },
        document_type: "external_content",
        publishing_app: "search-admin",
        schema_name: "external_content",
        update_type: "major",
      })
    end

    it "is valid against the external_content schema" do
      expect(validator).to be_valid
    end
  end

  describe "validations" do
    subject(:recommended_link) { build(:recommended_link, link:) }

    context "with an incomplete link" do
      let(:link) { "www.hello-world.com" }

      it "is invalid" do
        expect(recommended_link).not_to be_valid
        expect(recommended_link.errors.full_messages).to eq(["Link is an invalid URL"])
      end
    end

    context "with a link without a host" do
      let(:link) { "http:/path-not-host" }

      it "is invalid" do
        expect(recommended_link).not_to be_valid
        expect(recommended_link.errors.full_messages).to eq(["Link does not have a valid host"])
      end
    end

    context "with a duplicate link" do
      let(:link) { "https://www.tax.service.gov.uk/" }

      before do
        create(:recommended_link, link: link)
      end

      it "is invalid" do
        expect(recommended_link).not_to be_valid
        expect(recommended_link.errors.full_messages).to eq(["Link has already been taken"])
      end
    end
  end
end
