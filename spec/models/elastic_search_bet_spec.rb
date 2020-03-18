require "spec_helper"

describe ElasticSearchBet do
  let(:query) { create(:query, query: "jobs", match_type: "exact") }

  before do
    create(:bet, :best, link: "/jobs/inactive-jobs", position: 3, query: query, permanent: true, expiration_date: nil).deactivate

    create(:bet, :best, link: "/jobs/more-jobs", position: 2, query: query)
    create(:bet, :best, link: "/jobsearch", position: 1, query: query)

    create(:bet, :worst, link: "/topics/employment", query: query)
    create(:bet, :worst, link: "/people/steve-jobs", query: query)
  end

  it "builds an elasticsearch doc from the provided best bets" do
    es_bet = ElasticSearchBet.new(query)

    expect(es_bet.body).to eq(
      exact_query: "jobs",
      details: {
        best_bets: [
          { link: "/jobsearch", position: 1 },
          { link: "/jobs/more-jobs", position: 2 },
        ],
        worst_bets: [
          { link: "/people/steve-jobs" },
          { link: "/topics/employment" },
        ],
      }.to_json,
    )
  end
end
