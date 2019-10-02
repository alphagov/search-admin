require "spec_helper"

describe ElasticSearchRecommendedLink do
  let(:recommended_link) {
    create(:recommended_link,
           title: "Tax",
           link: "https://www.tax.service.gov.uk/",
           description: "Self assessment",
           keywords: "self, assessment, tax",
           content_id: SecureRandom.uuid)
  }

  it "builds an elasticsearch doc from the provided recommended link" do
    es_recommended_link = ElasticSearchRecommendedLink.new(recommended_link)

    expect(es_recommended_link.body).to eq(
      link: "https://www.tax.service.gov.uk/",
      details: {
        title: "Tax",
        link: "https://www.tax.service.gov.uk/",
        description: "Self assessment",
        format: "recommended-link",
        indexable_content: "self, assessment, tax",
      }.to_json,
    )
  end
end
