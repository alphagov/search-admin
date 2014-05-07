When(/^I view the best bets CSV$/) do
  visit best_bets_path(format: 'csv')
end

Then(/^I should see all best bets listed in the CSV$/) do
  check_for_best_bets_in_csv_format(@best_bets)
end
