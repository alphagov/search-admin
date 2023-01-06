require "spec_helper"
require "govuk_schemas/validator"

RSpec.describe ExternalContentPresenter do
  context "for the publishing API" do
    it "presents minimal external content to match the schema" do
      payload = ExternalContentPresenter.new(recommended_link).present_for_publishing_api

      expect(payload[:description]).to eq("Public data to help people understand how the government works")
      expect(payload[:title]).to eq("Data.gov.uk")
      expect(payload[:details][:url]).to eq("http://www.data.gov.uk/")
      expect(payload[:details][:hidden_search_terms]).to eq([])

      assert_valid_content_item(payload)
    end

    it "presents search keywords" do
      link = recommended_link(keywords: "data, open data, api")

      payload = ExternalContentPresenter.new(link).present_for_publishing_api

      expect(payload[:details][:hidden_search_terms]).to eq(["data, open data, api"])

      assert_valid_content_item(payload)
    end

    it "presents publishing details" do
      payload = ExternalContentPresenter.new(recommended_link).present_for_publishing_api

      expect(payload[:document_type]).to eq("external_content")
      expect(payload[:publishing_app]).to eq("search-admin")
      expect(payload[:schema_name]).to eq("external_content")
      expect(payload[:update_type]).to eq("minor")
    end

    def recommended_link(details = {})
      RecommendedLink.new({
        content_id: "some-content-id",
        description: "Public data to help people understand how the government works",
        link: "http://www.data.gov.uk/",
        title: "Data.gov.uk",
      }.merge(details))
    end

    def assert_valid_content_item(payload)
      validator = GovukSchemas::Validator.new(
        "external_content",
        "publisher",
        payload,
      )

      expect(validator.valid?).to be true
    end
  end
end
