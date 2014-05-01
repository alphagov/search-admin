When(/^I create a best bet$/) do
  create_best_bet(query: 'jobs')
end

Then(/^the best bet should be available on the index page$/) do
  check_for_best_bet_on_index_page('jobs')
end
