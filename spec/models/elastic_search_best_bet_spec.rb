require 'spec_helper'

describe ElasticSearchBestBet do
  before do
    bets_to_create = [
      {query: 'jobs', match_type: 'exact', link: '/jobs/more-jobs', position: 2},
      {query: 'jobs', match_type: 'exact', link: '/jobsearch', position: 1},
      {query: 'jobs', match_type: 'exact', link: '/topics/employment', position: nil},
      {query: 'jobs', match_type: 'exact', link: '/people/steve-jobs', position: nil}
    ]

    @matching_bets = bets_to_create.map do |best_bet_attributes|
      FactoryGirl.build(:best_bet, best_bet_attributes)
    end
  end

  it "builds an elasticsearch header from the provided best bets" do
    es_best_bet = ElasticSearchBestBet.from_matching_bets(@matching_bets)

    expect(es_best_bet.header).to eq(
      index: {
        _id: 'jobs-exact',
        _type: 'best_bet'
      }
    )
  end

  it "builds an elasticsearch doc from the provided best bets" do
    es_best_bet = ElasticSearchBestBet.from_matching_bets(@matching_bets)

    expect(es_best_bet.body).to eq(
      _id: 'jobs-exact',
      _type: 'best_bet',
      exact_query: 'jobs',
      details: {
        best_bets: [
          {link: '/jobsearch', position: 1},
          {link: '/jobs/more-jobs', position: 2}
        ],
        worst_bets: [
          {link: '/people/steve-jobs'},
          {link: '/topics/employment'}
        ]
      }.to_json
    )
  end

  it "complains if not given matching bets" do
    nonmatching_bets = [
      FactoryGirl.build(:best_bet, query: 'jobs', match_type: 'exact'),
      FactoryGirl.build(:best_bet, query: 'jobs', match_type: 'stemmed')
    ]

    expect{ElasticSearchBestBet.from_matching_bets(nonmatching_bets)}.to raise_error(ArgumentError)
  end
end
