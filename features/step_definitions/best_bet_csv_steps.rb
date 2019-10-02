When(/^I view the best bets CSV$/) do
  visit queries_path

  click_on "Download CSV"
end

Then(/^I should see all best bets listed in the CSV$/) do
  check_for_queries_in_csv_format(@queries)
end
