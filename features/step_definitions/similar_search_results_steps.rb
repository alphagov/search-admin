When(/^I visit the similar search results form$/) do
  visit root_path
  click_on "Similar search results"
end

When(/^I type in a valid GOV\.UK link with related items$/) do
  stub_request(
    :get,
    "https://search.test.gov.uk/search.json?fields%5B%5D=taxons&filter_link=/guidance/pupil-premium-reviews",
  ).to_return(
    body: {
      "results" => [{
        "link" => "/guidance/pupil-premium-reviews",
        "taxons" => %w[1ddd7a85-6c64-4b1e-9e54-55b50a0ae3f3],
      }],
    }.to_json,
  )

  stub_request(
    :get,
    /https:\/\/search.test.gov.uk\/search.json\?.*similar_to=\/guidance\/pupil-premium-reviews.*/,
  ).to_return(
    body: {
      "results" => [{
        "link" => "/similar-item",
        "title" => "Similar item",
        "es_score" => 20.97,
        "format" => "detailed_guidance",
        "content_store_document_type" => "detailed_guide",
      }],
    }.to_json,
  )

  fill_in "base_path", with: "/guidance/pupil-premium-reviews"
  click_on "Show similar search result"
end

Then(/^I should see all related items$/) do
  expect(current_path).to eq(similar_search_result_path(:result))
  expect(page).to_not have_selector(".alert")
  expect(page).to have_selector("table tbody tr", count: 1)
end
