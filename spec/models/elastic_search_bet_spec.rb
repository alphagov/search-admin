require 'spec_helper'

describe ElasticSearchBet do
  let(:query) { FactoryGirl.create(:query, query: 'jobs', match_type: 'exact') }

  before do
    FactoryGirl.create(:bet, :best, link: '/jobs/more-jobs', position: 2, query: query)
    FactoryGirl.create(:bet, :best, link: '/jobsearch', position: 1, query: query)

    FactoryGirl.create(:bet, :worst, link: '/topics/employment', query: query)
    FactoryGirl.create(:bet, :worst, link: '/people/steve-jobs', query: query)
  end

  it "builds an elasticsearch header from the provided query" do
    es_bet = ElasticSearchBet.new(query)

    expect(es_bet.header).to eq(
      index: {
        _id: 'jobs-exact',
        _type: 'best_bet'
      }
    )
  end

  it "builds an elasticsearch doc from the provided best bets" do
    es_bet = ElasticSearchBet.new(query)

    expect(es_bet.body).to eq(
      exact_query: 'jobs',
      details: {
        best_bets: [
          { link: '/jobsearch', position: 1 },
          { link: '/jobs/more-jobs', position: 2 }
        ],
        worst_bets: [
          { link: '/people/steve-jobs' },
          { link: '/topics/employment' }
        ]
      }.to_json
    )
  end
end
