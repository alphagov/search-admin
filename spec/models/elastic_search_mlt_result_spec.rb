require "spec_helper"

describe ElasticSearchMltResult do
  let(:attributes) do
    {
      title: "A related link",
      link: "/related-link",
      format: "guide",
      es_score: 20.21,
      content_store_document_type: "guide",
    }
  end
  let(:result) { described_class.new(attributes) }

  it "assigns the title" do
    expect(result.title).to eq(attributes[:title])
  end

  it "assigns the link" do
    expect(result.link).to eq(attributes[:link])
  end

  it "assigns the format" do
    expect(result.format).to eq(attributes[:format])
  end

  it "assigns the es_score" do
    expect(result.es_score).to eq(attributes[:es_score])
  end

  it "assigns the content_store_document_type" do
    expect(result.content_store_document_type).to eq(attributes[:content_store_document_type])
  end
end
