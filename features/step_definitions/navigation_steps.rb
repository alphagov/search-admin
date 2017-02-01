Given(/^I am viewing a specific query$/) do
  query = create(:query)
  visit query_path(query)
end

Then(/^I can click a link to navigate to the index of queries$/) do
  within(".breadcrumb") do
    click_link 'Queries'
  end

  expect(current_path).to eq queries_path
end

Given(/^I am viewing a specific external link$/) do
  recommended_link = create(:recommended_link)
  visit recommended_link_path(recommended_link)
end

Then(/^I can click a link to navigate to the index of external links$/) do
  within(".breadcrumb") do
    click_link 'External links'
  end

  expect(current_path).to eq recommended_links_path
end
