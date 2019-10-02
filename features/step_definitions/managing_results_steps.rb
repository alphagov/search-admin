When(/^I visit the results form$/) do
  visit root_path
  click_on "Search results"
end

When(/^I type in a valid GOV.UK link$/) do
  stub_request(:get, "https://search.test.gov.uk/content?link=/make-a-sorn").
    to_return(body: { "raw_source" => { "title" => "Stubbed page about SORN" } }.to_json)

  fill_in "base_path", with: "/make-a-sorn"
  click_on "Show search result"
end

Then(/^I should see all information about the link$/) do
  expect(page).to have_content "Stubbed page about SORN"
end

When(/^I click on the button to remove the result$/) do
  stub_request(:delete, "https://search.test.gov.uk/content?link=/make-a-sorn")
  stub_request(:get, "https://search.test.gov.uk/content?link=/make-a-sorn").
    to_return(status: 404)
  click_on "Remove result"
end

Then(/^the result should have been removed from the index$/) do
  expect(page).to have_content "That URL wasn't found."
end

When(/^I type in an non\-existing GOV\.UK link$/) do
  stub_request(:get, "https://search.test.gov.uk/content?link=/does-not-exist").
    to_return(status: 404)

  fill_in "base_path", with: "/does-not-exist"
  click_on "Show search result"
end

Then(/^I should see that the link is invalid$/) do
  expect(page).to have_content "That URL wasn't found."
end

When(/^I type in a locked GOV.UK link$/) do
  stub_request(:get, "https://search.test.gov.uk/content?link=/a-locked-document").
    to_return(body: { "raw_source" => { "title" => "Stubbed page about SORN" } }.to_json)


  fill_in "base_path", with: "/a-locked-document"
  click_on "Show search result"
end

When(/^I click on the button to remove the locked result$/) do
  stub_request(:delete, "https://search.test.gov.uk/content?link=/a-locked-document").
    to_return(status: 423, body: { "result" => "Index is locked." }.to_json)

  click_on "Remove result"
end

Then(/^I should see a message with locking error$/) do
  expect(page).to have_content "Index is locked."
end
