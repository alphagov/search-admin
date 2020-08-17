require "spec_helper"

describe Query do
  describe "#is_query?" do
    it "should return true" do
      query = create(:query)
      expect(query.is_query?).to eq true
    end
  end

  describe "#query_object" do
    it "should return itself" do
      query = create(:query)
      expect(query.query_object).to eq query
    end
  end

  describe "#sorted_best_bets" do
    it "sorts the best bets by position" do
      query = create(:query)
      create(:bet, query: query, position: 3)
      create(:bet, query: query, position: 1)
      create(:bet, query: query, position: 2)

      list = query.sorted_best_bets

      expect(list.map(&:position)).to eql [1, 2, 3]
    end
  end
end

describe Query, "associations" do
  it "should destroy associated bets on #destroy" do
    query = create :query
    bets = query.bets

    query.destroy!

    expect(bets).to eq []
  end
end

describe Query, "validations" do
  it "is invalid without a query attribute" do
    attributes = attributes_for(:query, query: nil)

    expect(new_query_with(attributes)).not_to be_valid
  end

  it "is invalid with a duplicate query/match_type" do
    create(:query, query: "jobs", match_type: "exact")

    bet = new_query_with(query: "jobs", match_type: "exact")

    expect(bet).to_not be_valid
  end

  it "validates inclusion of match_types in Query::MATCH_TYPES" do
    attributes = attributes_for(:query, match_type: "not like the others")

    expect(new_query_with(attributes)).not_to be_valid
  end

  it "is valid with a match_type of 'exact'" do
    attributes = attributes_for(:query, match_type: "exact")

    expect(new_query_with(attributes)).to be_valid
  end

  it "is valid with a match_type of 'stemmed'" do
    attributes = attributes_for(:query, match_type: "stemmed")

    expect(new_query_with(attributes)).to be_valid
  end
end

def new_query_with(attributes)
  Query.new(attributes)
end
