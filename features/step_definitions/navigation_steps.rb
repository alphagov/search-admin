Given(/^I am viewing a specific query$/) do
  query = FactoryGirl.create(:query)
  visit query_path(query)
end

Then(/^I can click a link to navigate to the index$/) do
  within(".breadcrumb") do
    click_link 'Queries'
  end

  expect(current_path).to eq queries_path
end
