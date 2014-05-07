When(/^I create a best bet$/) do
  create_best_bet(query: 'jobs')
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

When(/^I edit the best bet$/) do
  edit_best_bet(@best_bet, query: 'visas')
end

Then(/^the edited best bet should be available on the index page$/) do
  check_for_best_bet_on_index_page('visas')
end

When(/^I delete the best bet$/) do
  delete_best_bet(@best_bet)
end

Then(/^the best bet should not be available on the index page$/) do
  check_absence_of_best_bet_on_index_page('visas')
end
