When(/^I view the query$/) do
  visit query_path(@query)
end

Then(/^the worst bet should be listed on the query page$/) do
  check_for_worst_bet_on_query_page(worst_bet: @worst_bet)
end
