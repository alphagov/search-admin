When(/^I create a best bet$/) do
  create_query(query: "some jobs", match_type: "exact", links: [["/jobsearch", true, 1, "a comment"]])
end

When(/^I create a worst bet for a query$/) do
  create_query(query: "worst-bet", match_type: "exact", links: [["/worst-bet", false, nil, "a comment"]])
end

When(/^I create several exact best bets for the same query$/) do
  create_query(query: "jobs", match_type: "exact", links: [["/jobsearch", true, 1], ["/policy-areas/employment", true, 2]])
end

Then(/^the query should be listed on the index page$/) do
  check_for_query_on_index_page(
    query: "some jobs",
    match_type: "exact",
  )
end

Then(/^the best bet should be listed on the query page$/) do
  check_for_bet_on_query_page(
    comment: "a comment",
    is_best: true,
    link: "/jobsearch",
    match_type: "exact",
    position: 1,
    query: "some jobs",
  )
end

Given(/^a query exists$/) do
  @query = create(:query, :with_best_bet)
  @query.bets.each { |b| b.update_attribute(:link, "/jobsearch") }
end

Given(/^there are some best bets$/) do
  @queries = (1..3).map { |n|
    create(:query, query: "jobs-#{n}")
  }
end

Given(/^a variety of best bets exist$/) do
  jobs_query = create(:query, query: "jobs", match_type: "exact")
  create(:bet, :best, query: jobs_query, link: "/jobs-1", position: 1)
  create(:bet, :best, query: jobs_query, link: "/jobs-2", position: 2)

  visas_query = create(:query, query: "visas", match_type: "exact")
  create(:bet, :worst, query: visas_query, link: "/a-bad-visas-page")
end

Given(/^a query with a worst bet exists$/) do
  query = create(:query, :with_best_bet, query: "worst-bet", match_type: "exact")
  create(:bet, :worst, query: query, link: "/worst-bet", position: nil, comment: "a comment")
end

When(/^I edit a best bet$/) do
  edit_best_bet(@query.best_bets.first, "/job-policy")
end

Then(/^the edited best bet should be listed on the query page$/) do
  bet = @query.best_bets.first
  check_for_bet_on_query_page(
    link: "job-policy",
    is_best: bet.is_best?,
    position: bet.position,
    query: @query.query,
    match_type: @query.match_type,
  )
end

When(/^I delete the first best bet$/) do
  @bet = @query.best_bets.first
  delete_best_bet(@query, @bet)
end

When(/^I delete one of the best bets$/) do
  @query = Query.last
  delete_best_bet(@query, @query.best_bets.first)
end

When(/^I delete all the best bets$/) do
  @query_es_ids = []

  Query.all.each do |query|
    @query_es_ids << "#{query.query}-#{query.match_type}"

    query.bets.each do |bet|
      delete_best_bet(query, bet)
    end
  end
end

Then(/^the best bet should not be listed on the query page$/) do
  check_absence_of_best_bet_on_query_page(@query, @bet.link)
end

Then(/^the worst bet should be listed on the query page$/) do
  check_for_bet_on_query_page(
    comment: "a comment",
    is_best: false,
    link: "/worst-bet",
    match_type: "exact",
    position: nil,
    query: "worst-bet",
  )
end

Then("I should be a notified of the error") do
  expect(page).to have_content(/Error (creating|updating|deleting) (bet|query)/)
end

Then("the query should still be listed on the query index") do
  expect(Query.all).not_to be_empty
end

Then("the query should still be listed on the query index with best bet") do
  expect(Query.all).not_to be_empty
  expect(Query.first.best_bets).not_to be_empty
end

When("I delete the last bet") do
  @query = Query.last
  delete_best_bet(@query, @query.best_bets.first)
end

Then("no query should be listed on the query index") do
  expect(Query.count).to eq(1)
  expect(Bet.all).to be_empty
end
