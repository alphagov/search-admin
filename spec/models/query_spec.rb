require 'spec_helper'

describe Query do
  describe '#sorted_best_bets' do
    it "sorts the best bets by position" do
      query = FactoryGirl.create(:query)
      FactoryGirl.create(:bet, query: query, position: 3)
      FactoryGirl.create(:bet, query: query, position: 1)
      FactoryGirl.create(:bet, query: query, position: 2)

      list = query.sorted_best_bets

      expect(list.map(&:position)).to eql [1, 2, 3]
    end
  end
end

describe Query, 'associations' do
  it 'should destroy associated bets on #destroy' do
    query = FactoryGirl.create :query
    bets = query.bets

    query.destroy

    expect(bets).to eq []
  end
end

describe Query, 'validations' do
  it 'is invalid without a query attribute' do
    attributes = FactoryGirl.attributes_for(:query, query: nil)

    expect(new_query_with(attributes)).not_to be_valid
  end

  it "is invalid with a duplicate query/match_type" do
    FactoryGirl.create(:query, query: 'jobs', match_type: 'exact')

    bet = new_query_with(query: 'jobs', match_type: 'exact')

    expect(bet).to_not be_valid
  end

  it 'validates inclusion of match_types in Query::MATCH_TYPES' do
    attributes = FactoryGirl.
      attributes_for(:query, match_type: 'not like the others')

    expect(new_query_with(attributes)).not_to be_valid
  end

  it "is valid with a match_type of 'exact'" do
    attributes = FactoryGirl.
      attributes_for(:query, match_type: 'exact')

    expect(new_query_with(attributes)).to be_valid
  end

  it "is valid with a match_type of 'stemmed'" do
    attributes = FactoryGirl.
      attributes_for(:query, match_type: 'stemmed')

    expect(new_query_with(attributes)).to be_valid
  end
end

def new_query_with(attributes)
  Query.new(attributes)
end
