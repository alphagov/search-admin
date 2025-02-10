RSpec.describe FinderFrontendSearch do
  subject(:finder_frontend_search) { described_class.new(query_params) }

  let(:query_params) { { foo: "bar" } }

  describe ".for_keywords" do
    subject(:keyword_search) { described_class.for_keywords("foo bar") }

    it "generates the expected URL" do
      expect(keyword_search.url).to match(
        /\Ahttps:\/\/www\.test\.gov\.uk\/search\/all\?cachebust=[0-9a-f]+&keywords=foo\+bar\z/,
      )
    end
  end

  describe "#url" do
    it "generates the expected URL" do
      expect(finder_frontend_search.url).to match(
        /\Ahttps:\/\/www\.test\.gov\.uk\/search\/all\?cachebust=[0-9a-f]+&foo=bar\z/,
      )
    end
  end
end
