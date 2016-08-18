When(/^I view the recommended links CSV$/) do
  visit recommended_links_path

  click_on 'Download CSV'
end

Then(/^I should see all recommended links listed in the CSV$/) do
  check_for_recommended_links_in_csv_format(@recommended_links)
end
