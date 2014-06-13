require 'spec_helper'

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
