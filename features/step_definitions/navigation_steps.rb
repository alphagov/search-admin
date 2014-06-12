Given(/^I am viewing a specific query$/) do
  query = FactoryGirl.create(:query)
  visit query_path(query)
end

Then(/^I can click a link to navigate to the index$/) do
  click_link 'Return to query index'
  expect(current_path).to eq queries_path
end
