require "spec_helper"

describe ElasticSearchBetIDGenerator do
  describe ".generate(query, match_type)" do
    it "concatenates the `query` and `match_type` with a hyphen" do
      generated_id = ElasticSearchBetIDGenerator.generate("jobs", "exact")
      expect(generated_id).to eq("jobs-exact")
    end
  end
end
