When(/^I create a best bet$/) do
  create_best_bet(query: 'jobs', match_type: 'exact', link: '/jobsearch')
end

When(/^I create several exact best bets for the same query$/) do
  @best_bet_ids = [
    create_best_bet(query: 'jobs', match_type: 'exact', link: '/jobsearch'),
    create_best_bet(query: 'jobs', match_type: 'exact', link: '/policy-areas/employment'),
  ]
end

Then(/^the best bet should be available on the index page$/) do
  check_for_best_bet_on_index_page('jobs')
end

Given(/^a best bet exists$/) do
  @best_bet = FactoryGirl.create(:best_bet, query: 'jobs')
end

Given(/^there are some best bets$/) do
  @best_bets = (1..3).map { |n|
    FactoryGirl.create(:best_bet, query: "jobs-#{n}", link: "/jobs-#{n}")
  }
end

Given(/^a variety of best bets exist$/) do
  FactoryGirl.create(:best_bet, query: "jobs", match_type: "exact", link: "/jobs-1", position: 1)
  FactoryGirl.create(:best_bet, query: "jobs", match_type: "exact", link: "/jobs-2", position: 2)
  FactoryGirl.create(:best_bet, query: "visas", match_type: "exact", link: "/a-bad-visas-page", position: nil)
end

When(/^I edit the best bet$/) do
  edit_best_bet(@best_bet, query: 'visas')
end

Then(/^the edited best bet should be available on the index page$/) do
  check_for_best_bet_on_index_page('visas')
end

When(/^I delete the best bet$/) do
  delete_best_bet(@best_bet)
end

When(/^I delete one of the best bets$/) do
  delete_best_bet(BestBet.all.first)
end

When(/^I delete all the best bets$/) do
  BestBet.all.each do |bet|
    delete_best_bet(bet)
  end
end


Then(/^the best bet should not be available on the index page$/) do
  check_absence_of_best_bet_on_index_page('visas')
end
